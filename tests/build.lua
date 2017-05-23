-- main entry
function main(argv)

    -- generic?
    os.exec("xmake m -b")
    os.exec("xmake f -c")
    os.exec("xmake")
    os.exec("xmake p")
    os.exec("xmake c")
    os.exec("xmake f -m release")
    os.exec("xmake -r -a -v --backtrace")
    os.exec("xmake f --mode=debug --verbose --backtrace")
    os.exec("xmake --rebuild --all --verbose --backtrace")
    os.exec("xmake p --verbose --backtrace")
    os.exec("xmake c --verbose --backtrace")
    os.exec("xmake m -e buildtest")
    os.exec("xmake m -l")
    os.exec("xmake f --cc=gcc --cxx=g++")
    os.exec("xmake m buildtest")
    os.exec("xmake f --cc=clang --cxx=clang++ --ld=clang++ --verbose --backtrace")
    os.exec("xmake m buildtest")
    os.exec("xmake m -d buildtest")

    -- test iphoneos?
    if argv and argv.iphoneos then
        if os.host() == "macosx" then
            os.exec("xmake m package -p iphoneos")
        end
    end
end
