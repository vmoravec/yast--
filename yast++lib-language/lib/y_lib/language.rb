#--
# YaST++ Language Library
#
# Copyright (C) 2011 Novell, Inc. 
#   This library is free software; you can redistribute it and/or modify
# it only under the terms of version 2.1 or version 3 of the GNU Lesser General Public
# License as published by the Free Software Foundation. 
#
#   This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more 
# details. 
#
#   You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software 
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#++

$LOAD_PATH << File.dirname(__FILE__)

require 'config_agent/language'

# module for language configuration
module YLib
  module Language

    def self.last_error
      return @error
    end

    # Read all settings relevant for language configuration
    def self.read(params)
      # read config files    
      begin
        sysconfig_language	= ConfigAgent::Language.read({})
      rescue DbusClients::InsufficientPermission => e
        @error	= "User has no permission for action '#{e.permission}'."
        return nil
      end

      # TODO languages and use_utf8
      ret	= {
        "language"	=> sysconfig_language["RC_LANG"] || ""
      }
      rootlang		= sysconfig_language["ROOT_USES_LANG"]
      ret["rootlang"]	= rootlang unless rootlang == "ctype"

      return ret
    end
  end
end