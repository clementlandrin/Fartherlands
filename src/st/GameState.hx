package st;

class GameState extends State {
	@:s public var level : String;
	
	@:s public var goddess : ent.Goddess;
	
	@:s public var curRoomId : String;
	@:ignore public var curRoom : ent.Room;

	@:s public var knowledgeRoot : KnowledgeNode;

	public function new() {
		super();
		goddess = new ent.Goddess();
		knowledgeRoot = st.KnowledgeNode.buildTree();
	}
}