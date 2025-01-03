fun rFile f =
    let val is = TextIO.openIn f
        val s = TextIO.inputAll is
    in TextIO.closeIn is;
       s
    end

fun prln s = print(s ^ "\n")

val f =
    case CommandLine.arguments() of
      [f] => f
    | _ => (prln("Usage: " ^ CommandLine.name() ^ " file.apl");
            OS.Process.exit OS.Process.failure)

val c = rFile f

val ts = AplLex.lex f c

val () =
    let val (e,_) = AplParse.parse AplParse.env0 ts
    in prln(AplAst.pr_exp e)
     ; OS.Process.exit OS.Process.success
    end handle AplParse.ParseErr (l,msg) =>
               (prln ("Parse error at " ^ Region.ppLoc l ^ ":\n  " ^ msg);
                OS.Process.exit OS.Process.failure)
