--!The Make-like Build Utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2017, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        find_programver.lua
--

-- define module
local sandbox_lib_detect_find_programver = sandbox_lib_detect_find_programver or {}

-- load modules
local os        = require("base/os")
local path      = require("base/path")
local table     = require("base/table")
local utils     = require("base/utils")
local option    = require("base/option")
local cache     = require("project/cache")
local project   = require("project/project")
local sandbox   = require("sandbox/sandbox")
local raise     = require("sandbox/modules/raise")

-- find program version
--
-- @param program   the program
-- @param command   the version command, default: --version
-- @param parse     the version parse script or lua match pattern 
--
-- @return          the version string
--
-- @code
-- local version = find_programver("ccache")
-- local version = find_programver("ccache", "-v")
-- local version = find_programver("ccache", "--version", "(%d+%.?%d*%.?%d*.-)%s")
-- local version = find_programver("ccache", "--version", function (output) return output:match("(%d+%.?%d*%.?%d*.-)%s") end)
-- @endcode
--
function sandbox_lib_detect_find_programver.main(program, command, parse)

    -- get detect cache 
    local detectcache = cache(utils.ifelse(os.isfile(project.file()), "local.detect", "memory.detect"))
 
    -- attempt to get result from cache first
    local cacheinfo = detectcache:get("find_programver") or {}
    local result = cacheinfo[program]
    if result then
        return result
    end

    -- attempt to get version output info
    local ok, outdata = os.iorunv(program, {command or "--version"})

    -- find version info
    if ok and outdata and #outdata > 0 then
        if type(parse) == "function" then
            ok, result = sandbox.load(parse, outdata) 
            if not ok then
                utils.verror(result)
                result = nil
            end
        elseif parse == nil or type(parse) == "string" then
            result = outdata:match(parse or "(%d+%.?%d*%.?%d*.-)%s")
        end
    end

    -- cache result
    if result then
        cacheinfo[program] = result
        detectcache:set("find_program", cacheinfo)
        detectcache:flush()
    end

    -- ok?
    return result
end

-- return module
return sandbox_lib_detect_find_programver
