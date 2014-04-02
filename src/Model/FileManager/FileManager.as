package Model.FileManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package FileManager
	 * Le package FileManager contient l'ensemble des models
	 * interagissant avec des fichiers que ce soit en lecture
	 * ou en écriture
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - FileManager.as
	 * Ce model sert de première interface entre les vues et
	 * les models de traitement. C'est cette classe qui va
	 * déterminer les traitements à appliquer selon les actions
	 * de l'utilisateurs sur les views 
	 *****************************************************/
	
	import Model.FileManager.ExportManager.ExportManager;
	import Model.FileManager.ImportManager.ImportManager;
	
	import mx.collections.ArrayCollection;
	
	
	public class FileManager
	{
		// Notre instance d'import manager disponible en cas de demande d'import
		public var importManager:ImportManager = new ImportManager();
		
		// Notre instance d'export manager disponible en cas de demande d'import
		public var exportManager:ExportManager = new ExportManager();
			
		/**
		 * Createur
		 */
		public function FileManager()
		{
		}
		
		/**
		 * Fonction qui permet de lancer l'import d'un fichier de joueurs
		 * à travers l'import manager
		 */
		public function importPlayer():void
		{
			importManager.selectPlayerFile();
		}
		
		
		/**
		 * Fonction qui permet de lancer l'import d'un fichier de personnage
		 * à travers l'import manager
		 */
		public function importCharacter():void
		{
			importManager.selectCharacterFile();
		}
		
		/**
		 */
		public function exportCharacterModelFile():void
		{
			exportManager.exportCharacterModelFile();
		}
		
		public function exportPlayerModelFile():void
		{
			exportManager.exportPlayerModelFile();
		}
		
		public function exportCharacterReferentiel(parPlayerCharacterArray:ArrayCollection):void
		{
			exportManager.exportCharacterReferentiel(parPlayerCharacterArray);
		}
		
		public function exportPlayerReferentiel(parHumanPlayerArray:ArrayCollection):void
		{
			exportManager.exportPlayerReferentiel(parHumanPlayerArray);
		}
		
		public function exportCastingResult():void
		{
			exportManager.exportCastingResult();
		}
	}
}