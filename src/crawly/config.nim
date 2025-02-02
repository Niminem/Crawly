# loading/parsing/creating/accessing the config file
import std/[parsecfg, tables, streams, os]

type
    ConfigError* = object of CatchableError
    SpiderConfig* = Table[string, seq[tuple[key: string, value: string]]] # may want to use TableRef instead
                                                                          # i think strings are slow as shit

proc loadConfig*(configPath: string): SpiderConfig =
    var f = newFileStream(configPath, fmRead)
    doAssert f != nil: "cannot open " & configPath
    var p: CfgParser
    p.open(f, configPath)
    var currentSection: string
    while true:
        var e = p.next()
        case e.kind
        of cfgEof: break
        of cfgSectionStart:
            currentSection = e.section
            if not result.hasKey(currentSection):
                result[currentSection] = @[]
        of cfgKeyValuePair, cfgOption:
            doAssert currentSection != "": "key-value pair outside of section"
            result[currentSection].add((key: e.key, value: e.value))
        of cfgError:
            raise newException(ConfigError, e.msg)
    close(p)

when isMainModule:
    discard loadConfig(getCurrentDir() / "src" / "crawly" / "crawly.cfg")

# nim c -r src/crawly/config.nim

# TODO: let's focus on config file first
# - need initial list of arguments
# - give ability to add user-defined arguments that can be referenced
# - create load/parse/etc functions for interaction