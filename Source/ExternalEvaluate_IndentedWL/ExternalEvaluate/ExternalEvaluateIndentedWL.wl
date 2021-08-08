(* ::Package:: *)

(* ::Title:: *)
(*IndentedWL*)


BeginPackage["ExternalEvaluateIndentedWL`", {"ExternalEvaluate`", "PacletManager`"}]


(* ::Section:: *)
(*Transformer*)


Begin["`Transformer`Private`"]


(*\:8fd9\:4e2a\:51fd\:6570\:63a5\:6536\:591a\:4e2a\:5757*)
splitToSections[string_]:=
Module[ 
{delemitered},
delemitered=StringReplace[string,"\n"~~Except[WhitespaceCharacter,x_]->"delemiter\n"~~x];
StringSplit[delemitered,"delemiter\n"]
]


(*\:8fd9\:4e2a\:51fd\:6570\:53ea\:80fd\:63a5\:6536\:4e24\:884c\:6216\:8005\:4ee5\:4e0a\:7684\:8f93\:5165\:ff0c\:800c\:4e14\:7b2c\:4e00\:884c\:884c\:9996\:4e0d\:80fd\:662f\:7f29\:8fdb\:ff0c\:53ea\:80fd\:662f\:5b9e\:5b57\:7b26\:3002\:8fd4\:56de\:7684rest\:662f\:539f\:5b57\:6bb5\:53bb\:6389\:4e00\:6b21\:7f29\:8fdb\:7684\:7ed3\:679c*)
takeHeadAndRest[string_]:=
Module[
{num,head,rest},
num=StringPosition[string,"\n    "~~Except[WhitespaceCharacter,x_]][[1]][[1]];
head=StringTrim[StringTake[string,1;;num]];
rest=StringTake[string,num;;All];
rest=StringReplace[StringTrim[rest],"\n    "->"\n"];
{head,rest}
]


removeCommentLine[string_]:=
Which[
StringCases[string,"(*"~~x___~~"*)"]!={},"\n",
True,string
]


removeEmptyLine[string_]:=
Which[
StringMatchQ[string,Except["\n",Whitespace]],"",
True,string
]


processCommentsAndEmptyLine[string_]:=
StringTrim[
StringReplace[
StringJoin[
StringRiffle[
removeEmptyLine/@
(removeCommentLine/@
StringSplit[string,"\n"->"\n"]),
"\n"
]],
"\n"..->"\n"
]]


main[string_]:=Module[
{head,rest,processeRest,sections},
If[
StringCases[string,"\n"]=={},
ToExpression[string],
{head,rest}=takeHeadAndRest[string];
sections=splitToSections[rest];
ToExpression[head]@@Map[main,sections]
]];


ExternalEvaluateIndentedWL`Transformer`Transform[stringNotProcessed_]:=Module[
{sections,string},
string=processCommentsAndEmptyLine[stringNotProcessed];
sections=splitToSections[string];
If[Length[sections]==1,main[string],main/@sections]
]


End[]


(* ::Section:: *)
(*Modify Evaluator*)


Unprotect@ExternalEvaluate;
DownValues@ExternalEvaluate = DeleteDuplicates@Prepend[
	HoldPattern@ExternalEvaluate[ExternalSessionObject["IndentedWLDummy"], str_String] :> ExternalEvaluateIndentedWL`Transformer`Transform@str
]@DownValues@ExternalEvaluate;
Protect@ExternalEvaluate;


Unprotect@StartExternalSession;
DownValues@StartExternalSession = DeleteDuplicates@Prepend[
	HoldPattern@StartExternalSession[assoc_ /; assoc@"System" === "IndentedWL"] :> ExternalSessionObject["IndentedWLDummy"]
]@DownValues@StartExternalSession;
Protect@StartExternalSession;


(* ::Section:: *)
(*Register*)


$Icon = SetAlphaChannel[#, 1-Binarize@#]&@Import@PacletManager`PacletResource["Iconize", "defaultSpikey.png"];


ExternalEvaluate`RegisterSystem["IndentedWL",
    <|
        "Icon" -> $Icon,
        "IconCell" :> ToBoxes@$Icon,
        "ShowInFrontendCellQ" -> True,
        "PacletName" -> Automatic
    |>
  ];



EndPackage[]
