package Model.DataManager
{
	/**DESCRIPTION
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package DataManager
	 * Le package DataManager contient l'ensemble des models
	 * qui stockent l'ensembles des données de l'application.
	 * Ces données peuvent être stockés sous forme de liste
	 * ou de maps. Ainsi, lorsque l'on cherche une donnée
	 * de l'application, c'est une classe du DataManager que
	 * l'on appelle et qui fournis la donnée
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - DataManager.as
	 * Classe gérant l'ensemble des données du casting sous
	 * forme de collection afin d'être appelé à la fois par
	 * les models pour les traitements ou par les views pour
	 * l'affichage. Par conséquent et pour être sur de n'avoir
	 * qu'une seule version des donnéees à chaque instant,
	 * le DataManager est un singleton auquel on accède via
	 * son instance.
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	import DataObjects.Skill;
	
	import Model.CastingManager.CastingManager;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	
	public class DataManager
	{
		// Instance du singleton du DataManager
		private static var _instance:DataManager;
		
		// Collection contenant la liste de tous les joueurs
		/** DOCUMENTATION
		 * 2011-04-09 : Riyad YAKINE
		 * Actuellement bindé avec la DataGrid de la view de l'import
		 * afin de s'afficher dès l'import des données dans le gestionnaire
		 */
		[Bindable]
		public var humanPlayerArray:ArrayCollection = new ArrayCollection();
		
		// Collection contenant la liste des tous les personnages
		/** DOCUMENTATION
		 * 2011-04-09 : Riyad YAKINE
		 * Actuellement bindé avec la DataGrid de la view de l'import
		 * afin de s'afficher dès l'import des données dans le gestionnaire
		 */
		[Bindable]
		public var playerCharacterArray:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var originePlayerCharacterArray:ArrayCollection = new ArrayCollection();
		
		// Liste des skills
		[Bindable]
		public var skillsCastingArray:ArrayCollection = new ArrayCollection();
		
		// Le nombre de presonnage facultatif a utilisé
		public var nbCharacterFacultatifToKeep:int = 0;
		
		
		public function DataManager()
		{
			if(_instance != null)
				trace("Il ne peut exister qu'une seule instance du DataManager");
		}
		
		/**
		 * Fonction qui retourne l'instance du singleton DataManager 
		 */
		public static function getInstance():DataManager
		{
			if(_instance == null)
				_instance = new DataManager();
			
			return _instance;
		}
		
		public function refreshPlayerCharacterArray(event:CloseEvent = null):void
		{
			playerCharacterArray.refresh();	
		}
		
		public function refreshHumanPlayerArray(event:CloseEvent = null):void
		{
			humanPlayerArray.refresh();	
		}
		
		/** Fonction qui retourne le resultat de la recherche sur les personnages
		 *@param String la recherche
		 *@return Array le resultat de la recherche
		 */
		public function getPlayerCharacterArrayFromSearch(param:String):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			
			// Création regexp qui ignore la casse
			var pattern:RegExp = new RegExp(param,"ix");
			
			for each (var iter:PlayerCharacter in playerCharacterArray) 
			{
				if ((pattern.test(iter.firstName) == true)
					|| (pattern.test(iter.lastName) == true))
				{
					result.addItem(iter);
				}
			}						
			
			return result;
		}
		
		/** Fonction qui retourne le resultat de la recherche sur les joueurs
		 *@param String la recherche
		 *@return Array le resultat de la recherche
		 */
		public function getHumanPlayerArrayFromSearch(param:String):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			
			// Création regexp qui ignore la casse
			var pattern:RegExp = new RegExp(param,"ix");
			
			for each (var iter:HumanPlayer in humanPlayerArray) 
			{
				if ((pattern.test(iter.firstName) == true)
					|| (pattern.test(iter.lastName) == true))
				{
					result.addItem(iter);
				}
			}						
			
			return result;
		}
		
		public function setSkillCasting():void
		{
			skillsCastingArray = DataManager.getInstance().originePlayerCharacterArray.getItemAt(0).skillArray;
		}
		
		public function addSkillToCasting(skill:Skill):void
		{
			if (skill == null)
			{
				return;
			}
			
			for each (var s:Skill in skillsCastingArray) 
			{
				if (s.name == skill.name)
				{
					return;
				}
			}
			
			skillsCastingArray.addItem(skill);
			
			for each (var hp:HumanPlayer in humanPlayerArray) 
			{
				hp.skillArray.addItem(skill);
			}
			
			for each (var pc:PlayerCharacter in originePlayerCharacterArray) 
			{
				pc.skillArray.addItem(skill);
			}
			
			for each (var pc2:PlayerCharacter in playerCharacterArray) 
			{
				pc2.skillArray.addItem(skill);
			}
		}
		
		public function removeSkillToCasting(skill:Skill):void
		{
			if (skill == null)
			{
				return;
			}
			
			for (var i:int = 0; skill.name != (skillsCastingArray[i] as Skill).name; ++i) 
			{}
			
			if (i < skillsCastingArray.length)
			{
				skillsCastingArray.removeItemAt(i);
				
				for each (var hp:HumanPlayer in humanPlayerArray) 
				{
					hp.skillArray.removeItemAt(i);
				}
				
				for each (var pc:PlayerCharacter in originePlayerCharacterArray) 
				{
					pc.skillArray.removeItemAt(i);
				}
				
				for each (var pc2:PlayerCharacter in playerCharacterArray) 
				{
					pc2.skillArray.removeItemAt(i);
				}
			}			
		}
	}
}