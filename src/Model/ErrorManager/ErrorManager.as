package Model.ErrorManager
{
	/**DESCRIPTION
	 * 2011-04-11 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ErrorManager
	 * Le package ErrorManager contient l'ensemble des models
	 * qui stockent l'ensembles des erreurs de l'application.
	 * Ces erreurs peuvent être stockés sous forme de liste
	 * ou de maps. Ainsi, lorsque l'on cherche à renvoyer une
	 * erreur de l'application, c'est une classe de l'ErrorManager
	 * que l'on appelle et qui fournis le message d'erreur
	 *----------------------------------------------------
	 * 2011-04-11 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - ErrorManager.as
	 * Classe gérant l'ensemble des erreurs du casting sous
	 * forme de collection afin d'être appelé à la fois par
	 * les models pour les traitements ou par les views pour
	 * l'affichage. Par conséquent et pour être sur de n'avoir
	 * qu'une seule version des erreurs à chaque instant,
	 * le DataManager est un singleton auquel on accède via
	 * son instance.
	 *****************************************************/
	
	import mx.controls.Text;
	
	
	public class ErrorManager
	{
		// Instance du singleton du ErrorManager
		private static var _instance:ErrorManager;
		
		// Notre liste de message d'erreurs lié à l'ImportManager
		[Bindable]
		public var importErrorMessage:String = new String;
		
		public var importErrorMessageArray:Array = new Array();
		
		public function ErrorManager()
		{
			if(_instance != null)
				trace("Il ne peut exister qu'une seule instance de l'ErrorManager");
		}
		
		/**
		 * Fonction qui retourne l'instance du singleton DataManager 
		 */
		public static function getInstance():ErrorManager
		{
			if(_instance == null)
				_instance = new ErrorManager();
			
			return _instance;
		}
		
		/** DOCUMENTATION
		 * Fonction qui ajoute un message d'erreur à une erreur d'import
		 * @param String le message ajouté
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function addImportErrorMessage(errorMessage:String):void
		{
			importErrorMessageArray.push(errorMessage);
			trace ("Error msg: " + errorMessage);
			trace ("Error msg Array :" + importErrorMessageArray.length + " - " + importErrorMessageArray[importErrorMessageArray.length - 1]);
			importErrorMessage += importErrorMessageArray.length + ": " + errorMessage + "\n";
			trace ("Erreur :" + ErrorManager.getInstance().importErrorMessage);
		}
		
		/** DOCUMENTATION
		 * Fonction qui renvoit les erreurs formates
		 * @param void
		 * @return String les messages d'erreur
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function formattedErrors():String
		{
			var locFormattedErrors:String = new String();
			
			locFormattedErrors += "Erreurs d'import\n----------------\n";
			for (var i:int = 0; i < importErrorMessageArray.length - 1; i++)
			{
				locFormattedErrors += importErrorMessageArray[i].toString() + "\n";
			}
			return locFormattedErrors;
		}
	}
}