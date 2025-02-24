package("taskflow")

    set_kind("library", {headeronly = true})
    set_homepage("https://taskflow.github.io/")
    set_description("A fast C++ header-only library to help you quickly write parallel programs with complex task dependencies")
    set_license("MIT")

    add_urls("https://github.com/taskflow/taskflow.git")
    add_urls("https://github.com/taskflow/taskflow/archive/$(version).tar.gz")
    add_versions("v3.2.0", "26c37a494789fedc5de8d1f8452dc8a7774a220d02c14d5b19efe0dfe0359c0c")
    add_versions("v3.1.0", "17b56e23312d20c4ad5cc497b9f42cd0ad4451dbd2df0160a0a692fd16d47143")
    add_versions("v3.0.0", "553c88a6e56e115d29ac1520b8a0fea4557a5fcda1af1427bd3ba454926d03a2")

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_install(function (package)
        os.cp("taskflow", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <assert.h>
            static void test() {

                tf::Executor executor;
                tf::Taskflow taskflow;

                std::vector<int> range(10);
                std::iota(range.begin(), range.end(), 0);

                taskflow.for_each(range.begin(), range.end(), [&] (int i) {
                  printf("for_each on container item: %d\n", i);
                });

                executor.run(taskflow).get();
            }
        ]]}, {configs = {languages = "c++1z"}, includes = "taskflow/taskflow.hpp"}))
    end)

