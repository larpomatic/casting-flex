package Model.ViewManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ViewManager
	 * Le package ViewManager contient l'ensemble des fonctions
	 * utilisables pour gerer l'affichage des vues
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - CastingAlgoTools.as
	 * Classe qui contient les outils necessaires pour gérer les vues
	 *****************************************************/
	
	import mx.binding.utils.BindingUtils;

	public class ViewManager
	{
		// Instance du singleton du ViewManager
		private static var _instance:ViewManager;
		
		// Notre vue actuelle
		[Bindable]
		public var currentView:int = 1;
		
		// L'ensemble de nos vues
		public const IMPORT_VIEW:int = 0;
		public const COMPUTE_CASTING_VIEW:int = 1;
		
		public function ViewManager()
		{
			if(_instance != null)
				trace("Il ne peut exister qu'une seule instance du ViewManager");
		}
		
		/**
		 * Fonction qui retourne l'instance du singleton ViewManager 
		 */
		public static function getInstance():ViewManager
		{
			if(_instance == null)
				_instance = new ViewManager();
			
			return _instance;
		}
		
	}
}