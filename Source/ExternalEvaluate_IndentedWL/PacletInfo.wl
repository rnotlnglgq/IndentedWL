(* ::Package:: *)

Paclet[
	Name -> "ExternalEvaluate_IndentedWL",
	Version -> "0.0.0",
	WolframVersion -> "12+", (* Most versions are not tested. 12.0+ recommended. *)
	Description -> "Add an external language for replacing brackets by indentations.",
	Root -> ".",
	Loading -> Automatic,
	Extensions -> {
		{
			"Kernel",
			Root -> "ExternalEvaluate",
			Context -> {"ExternalEvaluateIndentedWL`"}
		},
		{
			"Resource",
			Root -> "ExternalEvaluate",
			Resources -> {
		    	{"System", "ExternalEvaluateIndentedWL.wl"}
	    	}
		},
		{"ExternalEvaluate", "Language" -> {"IndentedWL"}} 	
	}
]
