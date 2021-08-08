#!/usr/bin/env wolframscript
(* ::Package:: *)

SetDirectory@If[$Notebooks,
	NotebookDirectory[],
	DirectoryName@$InputFileName
]


PacletUninstall@"ExternalEvaluate_IndentedWL"


CreatePacletArchive[FileNameJoin@{"Source", "ExternalEvaluate_IndentedWL"}, "Paclets/"]


PacletInstall@%


(* ::ExternalLanguage:: *)
(*f*)
(*    a*)


PutSiteInfo[]


ResetDirectory[]
