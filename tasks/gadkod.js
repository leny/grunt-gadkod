
/*
 * grunt-gadkod
 * https://github.com/leny/grunt-gadkod
 *
 * Copyright (c) 2015 leny
 * Licensed under the MIT license.
 */
"use strict";
var chalk, gadkod;

chalk = require("chalk");

gadkod = require("gadkod");

module.exports = function(grunt) {
  var _gadkodTask;
  _gadkodTask = function() {
    var fNext, oOptions;
    fNext = this.async();
    oOptions = this.options({
      convert: false,
      encoding: "utf-8"
    });
    this.filesSrc.filter(function(sFilePath) {
      return grunt.file.exists(sFilePath) && grunt.file.isFile(sFilePath);
    }).forEach(function(sFilePath) {
      var _parse;
      _parse = function(oError, aResults) {
        if (oError) {
          grunt.log.error(oError);
          fNext(false);
        }
        grunt.log.writeln("");
        if (!aResults.length) {
          return grunt.log.writeln(chalk.green("✔ File " + (chalk.yellow(sFilePath)) + " is clean."));
        }
        console.log("???");
        if (oOptions.convert) {
          console.log("!!!");
          grunt.log.writeln("  ● " + (chalk.yellow(sFilePath)) + ":", chalk.green("✔ " + aResults.length + " suspicious character" + (aResults.length > 1 ? "s" : "")), "converted.");
          aResults.forEach(function(oResult) {
            return grunt.log.writeln("  ○ line " + (chalk.cyan(oResult.line)) + ", column " + (chalk.cyan(oResult.column + 1)) + ": found a " + (chalk.blue(oResult.character.source.name.toLowerCase())) + ", replaced by a " + (chalk.blue(oResult.character.replacement.name.toLowerCase())) + " (" + oResult.character.replacement.character + ").");
          });
          return fNext();
        }
        grunt.log.writeln("  ● " + (chalk.yellow(sFilePath)) + ":", chalk.red("⚠ " + aResults.length + " suspicious character" + (aResults.length > 1 ? "s" : "")), "found.");
        aResults.forEach(function(oResult) {
          return grunt.log.writeln("    ○ line " + (chalk.cyan(oResult.line)) + ", column " + (chalk.cyan(oResult.column + 1)) + ": found a " + (chalk.blue(oResult.character.source.name.toLowerCase())) + ", should probably be a " + (chalk.blue(oResult.character.replacement.name.toLowerCase())) + " (" + oResult.character.replacement.character + ").");
        });
        return fNext();
      };
      if (oOptions.convert) {
        console.log("---");
        return gadkod.convert(sFilePath, function(a, b) {
          return console.log(a, b);
        });
      } else {
        return gadkod.report(sFilePath, _parse);
      }
    });
    return void 0;
  };
  if (grunt.config.data.gadkod) {
    return grunt.registerMultiTask("gadkod", "Check inside your files for suspicious unicode characters in code (like greek question mark…)", _gadkodTask);
  } else {
    return grunt.registerTask("gadkod", "Check inside your files for suspicious unicode characters in code (like greek question mark…)", _gadkodTask);
  }
};
