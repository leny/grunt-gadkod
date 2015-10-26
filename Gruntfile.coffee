###
 * grunt-gadkod
 * https://github.com/Leny/grunt-gadkod
 *
 * Copyright (c) 2015 Leny
 * Licensed under the MIT license.
###

"use strict"

module.exports = ( grunt ) ->

    require( "matchdep" ).filterDev( "grunt-*" ).forEach grunt.loadNpmTasks

    grunt.initConfig
        coffeelint:
            options:
                arrow_spacing:
                    level: "error"
                camel_case_classes:
                    level: "error"
                duplicate_key:
                    level: "error"
                indentation:
                    level: "ignore"
                max_line_length:
                    level: "ignore"
                no_backticks:
                    level: "error"
                no_empty_param_list:
                    level: "error"
                no_stand_alone_at:
                    level: "error"
                no_tabs:
                    level: "error"
                no_throwing_strings:
                    level: "error"
                no_trailing_semicolons:
                    level: "error"
                no_unnecessary_fat_arrows:
                    level: "error"
                space_operators:
                    level: "error"
            task:
                files:
                    src: [ "src/*.coffee" ]
        coffee:
            options:
                bare: yes
            task:
                files:
                    "tasks/gadkod.js": "src/gadkod.coffee"
        copy:
            restore:
                files:
                    "test/convert.txt": "test/test.txt"
        gadkod:
            default:
                files:
                    src: [ "test/*.txt" ]
            convert:
                files:
                    src: [ "test/convert.txt" ]
                options:
                    convert: yes

    grunt.loadTasks "tasks"

    grunt.registerTask "default", [
        "coffeelint"
        "coffee"
        "gadkod"
    ]

    grunt.registerTask "build", [
        "coffeelint"
        "coffee"
    ]

    grunt.registerTask "test", [
        "copy:restore"
        "gadkod"
    ]
