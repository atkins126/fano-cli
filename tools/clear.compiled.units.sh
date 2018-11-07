#------------------------------------------------------------
# Fano CLI Application (https://fanoframework.github.io)
#
# @link      https://github.com/fanoframework/fano-cli
# @copyright Copyright (c) 2018 Zamrony P. Juhara
# @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (GPL 3.0)
#-------------------------------------------------------------
#!/bin/bash

#------------------------------------------------------
# Scripts to delete all compiled unit files
#------------------------------------------------------

find bin/unit ! -name 'README.md' -type f -exec rm -f {} +
