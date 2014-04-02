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
	 * Riyad YAKINE - AlgoParam.as
	 * Classe de lien entre l'IHM et les alogorithmes.
	 *****************************************************/
	
	public class AlgoParam
	{
		// Instance du singleton d'AlgoParam
		private static var _instance:AlgoParam;
		
		[Bindable]
		public var sexCriteria:Boolean = true;
		
		[Bindable]
		public var ponderationCriteria:Boolean = false;
		
		[Bindable]
		public var choosenAlgo:String = "";
		
		public function AlgoParam()
		{
			if(_instance != null)
				trace("Il ne peut exister qu'une seule instance d'AlgoParam");
		}
		
		public static function getInstance():AlgoParam
		{
			if(_instance == null)
				_instance = new AlgoParam();
			
			return _instance;
		}
	}
}