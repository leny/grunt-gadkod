###
 * grunt-gadkod
 * https://github.com/leny/grunt-gadkod
 *
 * Copyright (c) 2015 leny
 * Licensed under the MIT license.
###

"use strict"

chalk = require "chalk"
gadkod = require "gadkod"

module.exports = ( grunt ) ->

    _gadkodTask = ->
        fNext = @async()

        oOptions = @options
            convert: no
            encoding: "utf-8"

        @filesSrc
            .filter ( sFilePath ) ->
                grunt.file.exists( sFilePath ) and grunt.file.isFile( sFilePath )
            .forEach ( sFilePath ) ->
                _parse = ( oError, aResults ) ->
                    if oError
                        grunt.log.error oError
                        fNext no

                    grunt.log.writeln ""

                    return grunt.log.writeln chalk.green "✔ File #{ chalk.yellow sFilePath } is clean." unless aResults.length

                    if oOptions.convert

                        grunt.log.writeln "  ● #{ chalk.yellow sFilePath }:", ( chalk.green "✔ #{ aResults.length } suspicious character#{ if aResults.length > 1 then "s" else "" }" ), "converted."

                        aResults.forEach ( oResult ) ->
                            grunt.log.writeln "  ○ line #{ chalk.cyan oResult.line }, column #{ chalk.cyan oResult.column + 1 }: found a #{ chalk.blue oResult.character.source.name.toLowerCase() }, replaced by a #{ chalk.blue oResult.character.replacement.name.toLowerCase() } (#{ oResult.character.replacement.character })."

                        return fNext()

                    grunt.log.writeln "  ● #{ chalk.yellow sFilePath }:", ( chalk.red "⚠ #{ aResults.length } suspicious character#{ if aResults.length > 1 then "s" else "" }" ), "found."

                    aResults.forEach ( oResult ) ->
                        grunt.log.writeln "    ○ line #{ chalk.cyan oResult.line }, column #{ chalk.cyan oResult.column + 1 }: found a #{ chalk.blue oResult.character.source.name.toLowerCase() }, should probably be a #{ chalk.blue oResult.character.replacement.name.toLowerCase() } (#{ oResult.character.replacement.character })."

                    return fNext()

                if oOptions.convert
                    gadkod.convert sFilePath, oOptions, _parse
                else
                    gadkod.report sFilePath, _parse

        undefined

    if grunt.config.data.gadkod
        grunt.registerMultiTask "gadkod", "Check inside your files for suspicious unicode characters in code (like greek question mark…)", _gadkodTask
    else
        grunt.registerTask "gadkod", "Check inside your files for suspicious unicode characters in code (like greek question mark…)", _gadkodTask
