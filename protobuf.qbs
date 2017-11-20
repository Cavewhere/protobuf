import qbs 1.0

Project {
    name: "protobuf"

    property stringList protoIncludes: [
        "src"
    ]

    property stringList configIncludes: {
        if(qbs.targetOS.contains("osx")) {
            return ["config/osx"]
        } else if(qbs.targetOS.contains("windows")) {
            return ["config/windows"]
        } else if(qbs.targetOS.contains("linux")) {
            return ["config/linux"]
        }

        return [];
    }

    property stringList generalCxxFlags: {
        if(qbs.targetOS.contains("osx")) {
            return ["-stdlib=libc++",
                    "-std=c++11"]
        } else if(qbs.targetOS.contains("linux")) {
            return ["-std=c++11"]
        }

        return [];
    }

    property stringList defines: {
        if(qbs.targetOS.contains("windows")) {
            return ["_SCL_SECURE_NO_WARNINGS"]
        }
        return []
    }

    property stringList includes: {
        var osIncludePath = []
        if(qbs.targetOS.contains("linux")) {
            osIncludePath.push("/usr/include/c++/4.8")
            osIncludePath.push("/usr/include/x86_64-linux-gnu/c++/4.8/")
        }

        return protoIncludes.concat(configIncludes, osIncludePath)
    }

    property stringList protobufLiteSources: {

        var sources = [
                    "src/google/protobuf/stubs/common.cc",
                    "src/google/protobuf/stubs/once.cc",
                    "src/google/protobuf/stubs/hash.h",
                    "src/google/protobuf/stubs/map_util.h",
                    "src/google/protobuf/stubs/shared_ptr.h",
                    "src/google/protobuf/stubs/stringprintf.cc",
                    "src/google/protobuf/stubs/stringprintf.h",
                    "src/google/protobuf/extension_set.cc",
                    "src/google/protobuf/generated_message_util.cc",
                    "src/google/protobuf/message_lite.cc",
                    "src/google/protobuf/repeated_field.cc",
                    "src/google/protobuf/wire_format_lite.cc",
                    "src/google/protobuf/io/coded_stream.cc",
                    "src/google/protobuf/io/coded_stream_inl.h",
                    "src/google/protobuf/io/zero_copy_stream.cc",
                    "src/google/protobuf/io/zero_copy_stream_impl_lite.cc"
                ]

        if(qbs.targetOS.contains("linux")) {
            sources.push("src/google/protobuf/stubs/atomicops_internals_x86_gcc.cc");
        } else if(qbs.targetOS.contains("windows")) {
            sources.push("src/google/protobuf/stubs/atomicops_internals_x86_msvc.cc");
        }

        return sources;
    }


    StaticLibrary {
        name: "protobuf-lite"
        Depends { name: "cpp" }
        cpp.cxxFlags: project.generalCxxFlags
        cpp.includePaths: project.includes
        cpp.minimumMacosVersion: "10.7"
        cpp.warningLevel: "none"
        cpp.defines: project.defines
        files: protobufLiteSources
    }

    StaticLibrary {
        name: "protobuf"
        Depends { name: "cpp" }
        cpp.includePaths: project.includes
        cpp.cxxFlags: project.generalCxxFlags
        cpp.minimumMacosVersion: "10.7"
        cpp.warningLevel: "none"
        cpp.defines: project.defines

        Export {
            Depends { name: "cpp" }
            cpp.includePaths: project.includes
            cpp.cxxFlags: project.generalCxxFlags
        }

        files: protobufLiteSources.concat(
                   "src/google/protobuf/stubs/strutil.cc",
                   "src/google/protobuf/stubs/strutil.h",
                   "src/google/protobuf/stubs/substitute.cc",
                   "src/google/protobuf/stubs/substitute.h",
                   "src/google/protobuf/stubs/structurally_valid.cc",
                   "src/google/protobuf/descriptor.cc",
                   "src/google/protobuf/descriptor.pb.cc",
                   "src/google/protobuf/descriptor_database.cc",
                   "src/google/protobuf/dynamic_message.cc",
                   "src/google/protobuf/extension_set_heavy.cc",
                   "src/google/protobuf/generated_message_reflection.cc",
                   "src/google/protobuf/message.cc",
                   "src/google/protobuf/reflection_ops.cc",
                   "src/google/protobuf/service.cc",
                   "src/google/protobuf/text_format.cc",
                   "src/google/protobuf/unknown_field_set.cc",
                   "src/google/protobuf/wire_format.cc",
                   "src/google/protobuf/io/gzip_stream.cc",
                   "src/google/protobuf/io/printer.cc",
                   "src/google/protobuf/io/strtod.cc",
                   "src/google/protobuf/io/tokenizer.cc",
                   "src/google/protobuf/io/zero_copy_stream_impl.cc",
                   "src/google/protobuf/compiler/importer.cc",
                   "src/google/protobuf/compiler/parser.cc")

    }

    StaticLibrary {
        name: "protoc-library"
        Depends { name: "cpp" }
        cpp.includePaths: project.includes
        cpp.cxxFlags: project.generalCxxFlags
//        cpp.minimumMacosVersion: "10.7"
        cpp.warningLevel: "none"
        cpp.defines: project.defines
        files: [
            "src/google/protobuf/compiler/code_generator.cc",
            "src/google/protobuf/compiler/command_line_interface.cc",
            "src/google/protobuf/compiler/plugin.cc",
            "src/google/protobuf/compiler/plugin.pb.cc",
            "src/google/protobuf/compiler/subprocess.cc",
            "src/google/protobuf/compiler/subprocess.h",
            "src/google/protobuf/compiler/zip_writer.cc",
            "src/google/protobuf/compiler/zip_writer.h",
            "src/google/protobuf/compiler/cpp/cpp_enum.cc",
            "src/google/protobuf/compiler/cpp/cpp_enum.h",
            "src/google/protobuf/compiler/cpp/cpp_enum_field.cc",
            "src/google/protobuf/compiler/cpp/cpp_enum_field.h",
            "src/google/protobuf/compiler/cpp/cpp_extension.cc",
            "src/google/protobuf/compiler/cpp/cpp_extension.h",
            "src/google/protobuf/compiler/cpp/cpp_field.cc",
            "src/google/protobuf/compiler/cpp/cpp_field.h",
            "src/google/protobuf/compiler/cpp/cpp_file.cc",
            "src/google/protobuf/compiler/cpp/cpp_file.h",
            "src/google/protobuf/compiler/cpp/cpp_generator.cc",
            "src/google/protobuf/compiler/cpp/cpp_helpers.cc",
            "src/google/protobuf/compiler/cpp/cpp_helpers.h",
            "src/google/protobuf/compiler/cpp/cpp_message.cc",
            "src/google/protobuf/compiler/cpp/cpp_message.h",
            "src/google/protobuf/compiler/cpp/cpp_message_field.cc",
            "src/google/protobuf/compiler/cpp/cpp_message_field.h",
            "src/google/protobuf/compiler/cpp/cpp_options.h",
            "src/google/protobuf/compiler/cpp/cpp_primitive_field.cc",
            "src/google/protobuf/compiler/cpp/cpp_primitive_field.h",
            "src/google/protobuf/compiler/cpp/cpp_service.cc",
            "src/google/protobuf/compiler/cpp/cpp_service.h",
            "src/google/protobuf/compiler/cpp/cpp_string_field.cc",
            "src/google/protobuf/compiler/cpp/cpp_string_field.h",
            "src/google/protobuf/compiler/java/java_context.cc",
            "src/google/protobuf/compiler/java/java_context.h",
            "src/google/protobuf/compiler/java/java_enum.cc",
            "src/google/protobuf/compiler/java/java_enum.h",
            "src/google/protobuf/compiler/java/java_enum_field.cc",
            "src/google/protobuf/compiler/java/java_enum_field.h",
            "src/google/protobuf/compiler/java/java_extension.cc",
            "src/google/protobuf/compiler/java/java_extension.h",
            "src/google/protobuf/compiler/java/java_field.cc",
            "src/google/protobuf/compiler/java/java_field.h",
            "src/google/protobuf/compiler/java/java_file.cc",
            "src/google/protobuf/compiler/java/java_file.h",
            "src/google/protobuf/compiler/java/java_generator.cc",
            "src/google/protobuf/compiler/java/java_generator_factory.cc",
            "src/google/protobuf/compiler/java/java_generator_factory.h",
            "src/google/protobuf/compiler/java/java_helpers.cc",
            "src/google/protobuf/compiler/java/java_helpers.h",
            "src/google/protobuf/compiler/java/java_lazy_message_field.cc",
            "src/google/protobuf/compiler/java/java_lazy_message_field.h",
            "src/google/protobuf/compiler/java/java_message.cc",
            "src/google/protobuf/compiler/java/java_message.h",
            "src/google/protobuf/compiler/java/java_message_field.cc",
            "src/google/protobuf/compiler/java/java_message_field.h",
            "src/google/protobuf/compiler/java/java_name_resolver.cc",
            "src/google/protobuf/compiler/java/java_name_resolver.h",
            "src/google/protobuf/compiler/java/java_primitive_field.cc",
            "src/google/protobuf/compiler/java/java_primitive_field.h",
            "src/google/protobuf/compiler/java/java_shared_code_generator.cc",
            "src/google/protobuf/compiler/java/java_shared_code_generator.h",
            "src/google/protobuf/compiler/java/java_service.cc",
            "src/google/protobuf/compiler/java/java_service.h",
            "src/google/protobuf/compiler/java/java_string_field.cc",
            "src/google/protobuf/compiler/java/java_string_field.h",
            "src/google/protobuf/compiler/java/java_doc_comment.cc",
            "src/google/protobuf/compiler/java/java_doc_comment.h",
            "src/google/protobuf/compiler/python/python_generator.cc"
        ]
    }

    CppApplication {
        name: "protoc"
        consoleApplication: true
        type: "application"

        Depends { name: "protoc-library" }
        Depends { name: "protobuf" }

        cpp.cxxFlags: project.generalCxxFlags
        cpp.includePaths: project.includes
        cpp.minimumMacosVersion: "10.7"
        cpp.warningLevel: "none"
        cpp.defines: project.defines

//        Properties {
//            condition: qbs.targetOS.contains("osx")

//            cpp.dynamicLibraries: [
//                "c++"
//            ]
//        }

        files: [
            "src/google/protobuf/compiler/main.cc"
        ]
    }

    Product {
        name: "protoIncludes"
        type: "includes"

        files: [
            "src/google/protobuf/stubs/atomicops.h",
            "src/google/protobuf/stubs/atomicops_internals_arm_gcc.h",
            "src/google/protobuf/stubs/atomicops_internals_arm64_gcc.h",
            "src/google/protobuf/stubs/atomicops_internals_arm_qnx.h",
            "src/google/protobuf/stubs/atomicops_internals_atomicword_compat.h",
            "src/google/protobuf/stubs/atomicops_internals_generic_gcc.h",
            "src/google/protobuf/stubs/atomicops_internals_macosx.h",
            "src/google/protobuf/stubs/atomicops_internals_mips_gcc.h",
            "src/google/protobuf/stubs/atomicops_internals_pnacl.h",
            "src/google/protobuf/stubs/atomicops_internals_tsan.h",
            "src/google/protobuf/stubs/atomicops_internals_x86_gcc.h",
            "src/google/protobuf/stubs/atomicops_internals_x86_msvc.h",
            "src/google/protobuf/stubs/common.h",
            "src/google/protobuf/stubs/platform_macros.h",
            "src/google/protobuf/stubs/once.h",
            "src/google/protobuf/stubs/stl_util.h",
            "src/google/protobuf/stubs/template_util.h",
            "src/google/protobuf/stubs/type_traits.h",
            "src/google/protobuf/descriptor.h",
            "src/google/protobuf/descriptor.pb.h",
            "src/google/protobuf/descriptor_database.h",
            "src/google/protobuf/dynamic_message.h",
            "src/google/protobuf/extension_set.h",
            "src/google/protobuf/generated_enum_reflection.h",
            "src/google/protobuf/generated_message_util.h",
            "src/google/protobuf/generated_message_reflection.h",
            "src/google/protobuf/message.h",
            "src/google/protobuf/message_lite.h",
            "src/google/protobuf/reflection_ops.h",
            "src/google/protobuf/repeated_field.h",
            "src/google/protobuf/service.h",
            "src/google/protobuf/text_format.h",
            "src/google/protobuf/unknown_field_set.h",
            "src/google/protobuf/wire_format.h",
            "src/google/protobuf/wire_format_lite.h",
            "src/google/protobuf/wire_format_lite_inl.h",
            "src/google/protobuf/io/coded_stream.h",
            "src/google/protobuf/io/printer.h",
            "src/google/protobuf/io/strtod.h",
            "src/google/protobuf/io/tokenizer.h",
            "src/google/protobuf/io/zero_copy_stream.h",
            "src/google/protobuf/io/zero_copy_stream_impl.h",
            "src/google/protobuf/io/zero_copy_stream_impl_lite.h",
            "src/google/protobuf/compiler/code_generator.h",
            "src/google/protobuf/compiler/command_line_interface.h",
            "src/google/protobuf/compiler/importer.h",
            "src/google/protobuf/compiler/parser.h",
            "src/google/protobuf/compiler/plugin.h",
            "src/google/protobuf/compiler/plugin.pb.h",
            "src/google/protobuf/compiler/cpp/cpp_generator.h",
            "src/google/protobuf/compiler/java/java_generator.h",
            "src/google/protobuf/compiler/python/python_generator.h"
        ]
    }

    Product {
        name: "config"
        type: "includes"

        Group {
            name: "osx"
            condition: qbs.targetOS.contains("osx")
            files: [
                "config/osx/config.h"
            ]
        }

        Group {
            name: "linux"
            condition: qbs.targetOS.contains("linux")
            files: [
                "config/linux/config.h"
            ]
        }

        Group {
            name: "windows"
            condition: qbs.targetOS.contains("windows")
            files: [
                "config/windows/config.h"
            ]
        }
    }
}
