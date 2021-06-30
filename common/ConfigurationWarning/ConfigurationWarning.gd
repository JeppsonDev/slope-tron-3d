tool
extends Node

func __unpack_array(array:Array)->String:
	var s:String = "";
	
	for i in array:
		s += "'" + i + "', ";
		
	return s;

func generate_require_children(parent:Node, children:Array)->String:
	var result_array:Array;
	
	for i in children:
		if(!parent.get_node(i)):
			result_array.append(i);
			
	if(result_array.size() <= 0):
		return "";
		
	var unpacked_string = __unpack_array(result_array);
	
	return "Nodes [" + unpacked_string + "] required as children";
	
func generate_require_child(parent:Node, child:String)->String:
	return "" if parent.get_node(child) else "Node ['" + child  + "'] required as child";
