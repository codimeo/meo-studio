'use strict';

/* global module*/

module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
    // Metadata.
        pkg: grunt.file.readJSON('package.json'),
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %>' +
        '<%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
        // Task configuration.
        update_submodules: {
            default: {
                options: {
                    params: "--init --recursive"
                }
            }
        },
        clean: {
            meo: {
                src: [ 'meo',
                       'meoCloud' ],
            }
        },
        copy: {
            meo: {
                files: [
                    {
                        expand: true,
                        cwd: 'snapCloud/',
                        src: '**',
                        dest: 'meoCloud/',
                    },
                    {
                        expand: true,
                        cwd: 'Snap/',
                        src: '**',
                        dest: 'meo/',
                    },
                    {
                        src: 'meo/index.html',
                        dest: 'meo/index_snap.html',
                    },
                    {
                        expand: true,
                        cwd: 'src/meo',
                        src: [
                            'favicon.ico',
                            'meo.js',
                            'index.html',
                            'meo.html',
                            /* 'dist/**',
                            'libraries/**', */
                        ],
                        dest: 'meo/',
                        /* filter: function (filepath) {
                            return ![
                                'src/libraries/LIBRARIES',
                            ].includes(filepath);
                        } */
                    },
                    {
                        expand: true,
                        cwd: 'src/meoCloud',
                        src: '**',
                        dest: 'meoCloud/',
                    },
                    {
                        src: 'src/meoCloud/.env',
                        dest: 'meoCloud/.env',
                    },
                    {
                        expand: true,
                        cwd: 'src/meo',
                        src: '**',
                        dest: 'meo/',
                        filter: function (filepath) {
                            return ![
                                'src/meo/favicon.ico',
                                'src/meo/meo.js',
                                'src/meo/libraries/LIBRARIES',
                                'src/meo/Examples/EXAMPLES',
                            ].includes(filepath);
                        }
                    }
                ]
            }
        },
        eslint: {
            target: [
                'src/meo/*.js',
            ],
            watch: {
                meo: {
                    files: ['<%= eslint.target.src%>'],
                    tasks: ['eslint'],
                }
            }
        },
        concat:{
            options: {
                separator: '',
            },
            libraries: {
                src: ['meo/libraries/LIBRARIES', 'src/meo/libraries/LIBRARIES'],
                dest: 'meo/libraries/LIBRARIES',
            },
            examples: {
                src: ['meo/Examples/EXAMPLES', 'src/meo/Examples/EXAMPLES'],
                dest: 'meo/Examples/EXAMPLES',
            },
        },
    });

    // These plugins provide necessary tasks.
    grunt.loadNpmTasks('grunt-eslint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-update-submodules');
    grunt.loadNpmTasks('grunt-contrib-concat');
    //grunt.loadNpmTasks('grunt-contrib-uglify');
    //grunt.loadNpmTasks('grunt-contrib-nodeunit');
    //grunt.loadNpmTasks('grunt-contrib-jshint');

    // Default task.
    grunt.registerTask('default', ['eslint', 'clean', 'copy', 'concat']);
    grunt.registerTask('build', ['eslint', 'clean', 'copy', 'concat']);
    grunt.registerTask(
        'full_build', 
        ['update_submodules', 'eslint', 'clean', 'copy', 'concat']
    );
};
