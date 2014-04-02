package Model.AlgoManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package AlgoManager
	 * Le package AlgoManager contient l'ensemble des models
	 * interagissant avec l'AlgoManager. C'est l'AlgoManager
	 * qui va appeler les différents appels aux algos d'association.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - ComputeAlgoEvent.as
	 * Classe useless
	 *****************************************************/
	
	import flash.events.Event;
	
	public class ComputeAlgoEvent extends Event
	{
		public var index : int = 0;
		
		public function ComputeAlgoEvent(type:String, index : int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.index = index;
		}
	}
}