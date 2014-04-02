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
	 * Riyad YAKINE - ImportParser.as
	 * Classe interne au package ImportManager, elle permet de 
	 * transformer les données du fichier CSV en token exploitable
	 * pour la validation des données (via ImportValidator) ou la
	 * création des données (via ImportCreator). Cette classe
	 * ne communique qu'à travers l'ImportManager
	 *****************************************************/
	
	import Model.ErrorManager.ErrorManager;
	
	import flash.net.FileReference;
	
	internal class ImportParser
	{
		
		function ImportParser()
		{
		}
		
		/**
		 * Fonction qui construit la matrice de token à partir du fichier CSV
		 * importé. Cette matrice de token est découpé selon la même organisation
		 * que le fichier CSV (on y retrouve les même cellules)
		 */
		public static function parseFile(fileToParse:FileReference):Array
		{
			var locLineArray:Array = null;
			var locLine:String = null;
			var locTokenArray:Array = new Array();;
			
			locLineArray = (fileToParse.data.toString()).split('\n');
			locLineArray.pop();
			
			trace("nb line:" + locLineArray.length.toString());
			
			for each (locLine in locLineArray)
			{					
				locTokenArray.push(locLine.split(";"));
			}
			
			return locTokenArray;
		}
	}
}