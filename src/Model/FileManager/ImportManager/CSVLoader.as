package Model.FileManager.ImportManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ImportManager
	 * Le package ImportManager contient l'ensemble des models
	 * interagissant avec l'ImportManager. C'est l'ImportManager
	 * qui va appelé les différents models de traitements pour
	 * charger les fichier, les parser, les valider et créer les
	 * données associées.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - CSVLoader.as
	 * Classe interne au package ImportManager, elle permet de
	 * charger un fichier CSV dans l'application. Cette classe
	 * ne communique qu'avec l'ImportManager
	 *****************************************************/
	
	import Model.ErrorManager.ErrorManager;
	
	import flash.events.*;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	internal class CSVLoader
	{
		
		// Notre attribut qui stockera le fichier ouvert
		public var csvFile:FileReference = new FileReference();
		
		
		public function CSVLoader()
		{
		}
		
		/**
		 * Fonction permettant d'ouvrir l'explorateur de ficher et de spécifier
		 * le type de fichier attendu.
		 */
		public function openBroswerFile():void
		{
			csvFile.addEventListener(Event.SELECT, onFileSelected); 
			csvFile.addEventListener(Event.CANCEL, onCancel); 
			csvFile.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
			csvFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError); 
			
			var locCSVTypeFilter:FileFilter = new FileFilter("Fichier CSV (*.csv)", "*.csv"); 
			csvFile.browse([locCSVTypeFilter]); 
		}
		
		/**
		 * Fonction permettant de charger le fichier sélectionné par l'utilisateur
		 */
		public function onFileSelected(evt:Event):void 
		{ 
			csvFile.addEventListener(ProgressEvent.PROGRESS, onProgress); 
			csvFile.addEventListener(Event.COMPLETE, onComplete); 
			csvFile.load();
		} 
		
		/**
		 * Fonction permettant d'afficher dans la console l'état du chargement du fichier 
		 */ 
		public function onProgress(evt:ProgressEvent):void 
		{ 
			trace ("Chargement de " + evt.bytesLoaded + " sur " + evt.bytesTotal + " octets."); 
		} 
		
		/**
		 * Fonction permettant de signaler que le fichier à été chargé entièrement
		 */
		public function onComplete(evt:Event):void
		{ 
			ErrorManager.getInstance().addImportErrorMessage("Le fichier a été correctement chargé.");
		} 
		
		/**
		 * Fonction permettant à l'utilisateur de refermer l'explorateur et de ne charger
		 * aucun fichier
		 */
		public function onCancel(evt:Event):void 
		{ 
			trace("La séléction à été annulé par l'utilisateur."); 
		} 
		
		/**
		 * Fonction permettant d'indiquer une erreur de chargement
		 */
		public function onIOError(evt:IOErrorEvent):void 
		{ 
			ErrorManager.getInstance().addImportErrorMessage("Erreur d'E/S."); 
		} 
		
		/**
		 * Fonction permettant de signer une erreur d'accès sur le fichier
		 */
		public function onSecurityError(evt:Event):void 
		{ 
			ErrorManager.getInstance().addImportErrorMessage("Erreur de sécurité."); 
		} 
	}
}