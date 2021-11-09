local c_params = {
    retrieve = "first",
    node_type = "parameter_list",
    subtree = {
        {
            retrieve = "all",
            node_type = "parameter_declaration",
            subtree = {
                { retrieve = "first", recursive = true, node_type = "identifier", extract = true },
            },
        },
        {
            retrieve = "all",
            node_type = "optional_parameter_declaration",
            subtree = {
                { retrieve = "first", recursive = true, node_type = "identifier", extract = true },
            },
        },
    },
}

local t_params = {
	{
		retrieve = "all",
		node_type = "type_parameter_declaration",
		subtree = {
			{ retrieve = "first", node_type = "type_identifier", extract = true },
		},
	},
	{
		retrieve = "all",
		node_type = "optional_type_parameter_declaration",
		subtree = {
			{ retrieve = "first", node_type = "type_identifier", extract = true },
		},
	},
}

local cpp_function_extractor = function(node)
	local tree = {
		{
			retrieve = "first",
			node_type = "function_declaration",
			subtree = {
				c_params,
			},
		},
		{
			retrieve = "first",
			recursive = true,
			node_type = "function_declarator",
			extract = true,
		},
		{
			retrieve = "first",
			node_type = "compound_statement",
			subtree = {
				{ retrieve = "first", node_type = "return_statement", extract = true },
			},
		},
		{
			retrieve = "first",
			node_type = "primitive_type",
			extract = true,
		},
		{
			retrieve = "first",
			node_type = "pointer_declarator",
			extract = true,
		},
		c_params,
		{
			retrieve = "first",
			node_type = "template_parameter_list",
			extract = true,
		}
	}

    local nodes = neogen.utilities.nodes:matching_nodes_from(node, tree)
    local res = neogen.utilities.extractors:extract_from_matched(nodes)

    if nodes.function_declarator then
        local subnodes = neogen.utilities.nodes:matching_nodes_from(nodes.function_declarator[1], tree)
        local subres = neogen.utilities.extractors:extract_from_matched(subnodes)
        res = vim.tbl_deep_extend("keep", res, subres)
    end
	if nodes.template_parameter_list then
        local subnodes = neogen.utilities.nodes:matching_nodes_from(nodes.template_parameter_list[1], t_params)
        local subres = neogen.utilities.extractors:extract_from_matched(subnodes)
        res = vim.tbl_deep_extend("keep", res, subres)
	end

    local has_return_statement = function()
        if res.return_statement then
            -- function implementation
            return res.return_statement
        elseif res.function_declarator and res.primitive_type then
            if res.primitive_type[1] ~= "void" or res.pointer_declarator then
                -- function prototype
                return res.primitive_type
            end
        end
        -- not found
        return nil
    end

    return {
        parameters = res.identifier,
		template_parameters = res.type_identifier,
        return_statement = has_return_statement(),
    }
end


return {
    parent = {
        func = { "function_declaration", "function_definition", "declaration" },
    },

    data = {
        func = {
            ["function_declaration|function_definition|declaration|template_declaration"] = {
                ["0"] = {
                    extract = cpp_function_extractor,
                },
            },
        },
    },

	locator = function(node_info, nodes_to_match)
		local result = neogen.default_locator(node_info, nodes_to_match)
		if not result then
			return nil
		end
		-- if the function happens to be a function template we want to place
		-- the annotation before the template statement and extract the
		-- template parameter names as well
		if "template_declaration" == node_info.current:parent():type() then
			-- parent of the function declarition shoul be the template
			-- declaration
			return result:parent()
		end
		return result
	end,

    -- Use default granulator and generator
    granulator = nil,
    generator = nil,

	template = {
		annotation_convention = "doxygen_javadoc_excl",
		use_default_comment = false,

		doxygen_javadoc_excl = {
			{ nil, "//! $1", { no_results = true } },
			{ nil, "//! $1" },
			{ nil, "//!" },
			{ "template_parameters", "//! \\tparam %s $1" },
			{ "parameters", "//! \\param[in] %s $1" },
			{ "return_statement", "//! \\return $1" },
		},
	},
}
