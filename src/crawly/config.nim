# loading/parsing/creating/accessing the config file
import std/[parsecfg, tables, streams, os]

type
    ConfigError* = object of CatchableError
    SpiderConfig* = Table[string, string] # ??? probably not.


proc loadConfig*(configPath: string) =
    var f = newFileStream(configPath, fmRead)
    doassert f != nil, "cannot open " & configPath # will work in release mode (TODO: add error handling)
    var p: CfgParser
    p.open(f, configPath)
    while true:
        var e = next(p)
        case e.kind
        of cfgEof: break
        of cfgSectionStart:
            echo "new section: " & e.section
        of cfgKeyValuePair, cfgOption:
            echo "argument: " & e.key & " = " & e.value
        of cfgError:
            echo e.msg # TODO: add error handling... perhaps adding ability for a callback
    close(p)

loadConfig(getCurrentDir() / "src" / "crawly" / "crawly.cfg")

# nim c -r src/crawly/config.nim

# TODO: let's focus on config file first
# - need initial list of arguments
# - give ability to add user-defined arguments that can be referenced
# - create load/parse/etc functions for interaction