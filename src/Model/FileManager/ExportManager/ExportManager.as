package Model.FileManager.ExportManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ImportManager
	 * Le package ExportManager contient l'ensemble des models
	 * interagissant avec l'ExportManager. C'est l'ExportManager
	 * qui va appeler les différents models de traitements pour
	 * charger les fichiers, les parsers, les valider et créer les
	 * données associées.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - ExportManager.as
	 * Seul fichier du package à être en public, c'est lui qui
	 * va chercher les différents appels au loader de fichier,
	 * au parser, au validateur et enfin au créateur de donnée.
	 * L'export manager est directement appelé par le FileManager
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	import DataObjects.Skill;
	
	import Model.CastingManager.CastingAssociation;
	import Model.CastingManager.CastingManager;
	import Model.CastingManager.CastingSession;
	
	import flash.errors.EOFError;
	import flash.globalization.StringTools;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import spark.globalization.StringTools;
	
	
	public class ExportManager
	{
		public const CONST_CHARACTER_FILE_HEADER:String = "Prénom;Nom;Sexe;Joue avec;Joue sans;Joueur prefere;Joueur facultatif;";
		public const CONST_PLAYER_FILE_HEADER:String = "Prénom;Nom;Sexe;Session avec;Session sans;Joue avec;Joue sans;Joueur interdit;Joue avec obligatoire;";
		public const CONST_CASTING_FILE_HEADER:String = "Session;Personnage;Joueur;Score d'interprétation;Score de compétences;Score de respect des choix du joueur;Score de joue avec;Score de joue sans;Score de session avec;Score de session sans;Ecart à la moyenne d'interprétation du personnage\r";
		
		public function ExportManager()
		{
		}
		
		/** DOCUMENTATION
		 * Fonction qui creer un model de fichier d'un personage
		 * @param void
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function exportCharacterModelFile():void
		{
			var fileReference:FileReference = new FileReference();
			var text:ByteArray = new ByteArray();
			text.writeMultiByte(CONST_CHARACTER_FILE_HEADER + "Nom de la compétence 1;Nom de la compétence 2;Nom de la compétence N\n" +
				"Prénom du personnage;Nom du personnage;Sexe du personnage;Liste des personnages partageant de nombreuses scènes;Liste des personnages partageant peu de scènes;Joueur qui devrait incarner le personnage;Joueur qui ne devrait pas incarner le personnage;Score de maitrise de la compétence 1;Score de maitrise de la compétence 2;Score de maitrise de la compétence N\n" +
				";;M pour Masculin, F pour Féminin et N pour Neutre;Le format de la liste est le suivant : Prénom1 Nom1, Prénom2 Nom2;Le format de la liste est le suivant : Prénom1 Nom1, Prénom2 Nom2;Le format est le suivant : Prénom Nom;Valeur comprise entre 1 et 9 exclusivement;Valeur comprise entre 1 et 9 exclusivement;Valeur comprise entre 1 et 9 exclusivement", "latin1");
			fileReference.save(text, "GNK-Modèle_fichier_personnages.csv");
		}
		
		/** DOCUMENTATION
		 * Fonction qui creer un fichier de personnage à partir d'un personnage existant 
		 * @param Array les caracteristiques de personnages sousforme d'un tableau
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function exportCharacterReferentiel(parPlayerCharacterArray:ArrayCollection):void
		{
			var fileReference:FileReference = new FileReference();
			var text:ByteArray = new ByteArray();
			text.writeMultiByte(CONST_CHARACTER_FILE_HEADER + buildEntitySkillHeaderExportData((parPlayerCharacterArray[0] as PlayerCharacter).skillArray) +
				buildPlayerCharacterReferentielData(parPlayerCharacterArray), "latin9");
			fileReference.save(text, "GNK-Export_des_personnages.csv");
		}
		
		/** DOCUMENTATION
		 * Fonction qui met toutes les caracteristiques d'un personnage au format csv 
		 * @param Array les personnages sous forme d'un tableau
		 * @return String les meme personnages sous forme de string (format csv)
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildPlayerCharacterReferentielData(parPlayerCharacterArray:ArrayCollection):String
		{
			var locResult:String = "";
			
			for each (var locPlayerCharacter:PlayerCharacter in parPlayerCharacterArray)
			{
				locResult += buildPlayerCharacterExportData(locPlayerCharacter);
			}
			
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui met une caracteristique d'un personnage au format csv
		 * @param PlayerCharacter les caracteristiques d'un personnage
		 * @return String les meme caracteristiques sous forme de string (format csv)
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildPlayerCharacterExportData(parPlayerCharacter:PlayerCharacter):String
		{
			var locResult:String = "";
			var i:int;
			
			locResult += parPlayerCharacter.firstName + ";";
			locResult += parPlayerCharacter.lastName + ";";
			locResult += parPlayerCharacter.sex + ";";
			locResult += buildEntityListExportData(parPlayerCharacter.playWithArray) + ";";
			locResult += buildEntityListExportData(parPlayerCharacter.playWithoutArray) + ";";
			locResult += buildEntityListExportData(parPlayerCharacter.wannaPlayCharacter) + ";";
			
			if (parPlayerCharacter.isFacultatif == true)
			{
				locResult += "Yes;";
			}
			else
			{
				locResult += "No;";
			}
			locResult += buildEntitySkillListExportData(parPlayerCharacter.skillArray) + '\n';
			
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui creer un model de fichier pour joueur au format csv
		 * @param void
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function exportPlayerModelFile():void
		{
			var fileReference:FileReference = new FileReference();
			var text:ByteArray = new ByteArray();
			text.writeMultiByte(CONST_PLAYER_FILE_HEADER +
				"Nom de la compétence 1;Nom de la compétence 2;Nom de la compétence N" + '\n' +
				"Prénom du joueur;Nom du joueur;Sexe du joueur;Liste des joueurs jouant dans la même session;Liste des joueurs ne jouant pas dans la même session;Liste des joueurs partageant de nombreuses scènes;Liste des joueurs partageant peu de scènes;Score de maitrise de la compétence 1;Score de maitrise de la compétence 2;Score de maitrise de la compétence N" + '\n' +
				";;M pour Masculin, F pour Féminin et N pour Neutre;Le format de la liste est le suivant : Prénom1 Nom1, Prénom2 Nom2;Le format de la liste est le suivant : Prénom1 Nom1, Prénom2 Nom2;Le format de la liste est le suivant : Prénom1 Nom1, Prénom2 Nom2;Le format de la liste est le suivant : Prénom1 Nom1, Prénom2 Nom2;Valeur comprise entre 1 et 9 exclusivement;Valeur comprise entre 1 et 9 exclusivement;Valeur comprise entre 1 et 9 exclusivement", "latin1");
			fileReference.save(text, "GNK-Modèle_fichier_joueurs.csv");
		}
		
		/** DOCUMENTATION
		 * Fonction qui creer un fichier de joueur à partir d'un joueur existant au format csv
		 * @param Array les joueurs
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function exportPlayerReferentiel(parHumanPlayerCharacterArray:ArrayCollection):void
		{
			var fileReference:FileReference = new FileReference();
			var text:ByteArray = new ByteArray();
			text.writeMultiByte(CONST_PLAYER_FILE_HEADER + buildEntitySkillHeaderExportData((parHumanPlayerCharacterArray[0] as HumanPlayer).skillArray) +
				buildHumanPlayerReferentielData(parHumanPlayerCharacterArray), "latin1");
			fileReference.save(text, "GNK-Export_des_joueurs.csv");
		}
		
		/** DOCUMENTATION
		 * Fonction qui met toutes les caracteristiques d'un joueur au format csv
		 * @param Array les caracteristiques du joueur
		 * @return String les caracteristiques de joueurs au format csv
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildHumanPlayerReferentielData(parHumanPlayerArray:ArrayCollection):String
		{
			var locResult:String = "";
			
			for each (var locHumanPlayer:HumanPlayer in parHumanPlayerArray)
			{
				locResult += buildHumanPlayerExportData(locHumanPlayer);
			}
			
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui met une caracteristique d'un joueur au format csv 
		 * @param HumanPlayer les caracteristiques d'un joueur
		 * @return String les meme caracteristiques au format csv
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildHumanPlayerExportData(parHumanPlayer:HumanPlayer):String
		{
			var locResult:String = "";
			var i:int;
			
			locResult += parHumanPlayer.firstName + ";";
			locResult += parHumanPlayer.lastName + ";";
			locResult += parHumanPlayer.sex + ";";
			locResult += buildEntityListExportData(parHumanPlayer.inSameSessionArray) + ";";
			locResult += buildEntityListExportData(parHumanPlayer.inOtherSessionArray) + ";";
			locResult += buildEntityListExportData(parHumanPlayer.playWithArray) + ";";
			locResult += buildEntityListExportData(parHumanPlayer.playWhitoutArray) + ";";
			locResult += buildEntityListExportData(parHumanPlayer.notCharacterAssociateArray) + ";";
			locResult += buildEntityListExportData(parHumanPlayer.playWithMendatoryArray) + ";";
			locResult += buildEntitySkillListExportData(parHumanPlayer.skillArray) + "\n";
			
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui met une entité au format csv 
		 * @param Array un tableau d'entité 
		 * @return String les meme entité au format csv
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildEntityListExportData(parEntityArray:ArrayCollection):String
		{
			var locResult:String = "";
			
			for (var i:int = 0; i < parEntityArray.length; ++i)
			{
				if (i > 0)
				{
					locResult += ", "
				}
				
				locResult += parEntityArray[i];
			}
//			locResult = locResult.substr(0, locResult.length - 2);
			
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui met une liste de caracteristique au format csv 
		 * @param Array la liste de caracteristique
		 * @return String les meme caracteristiques au format csv
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildEntitySkillListExportData(parSkillArray:ArrayCollection):String
		{
			var locResult:String = "";
			
			for each (var locSkill:Skill in parSkillArray)
			{
				locResult += locSkill.capacity.toString() + ";";
			}
			
			locResult = locResult.substr(0, locResult.length - 1);
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui met une liste de caracteristique au format csv 
		 * @param Array la liste de caracteristique
		 * @return String les meme caracteristiques au format csv
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildEntitySkillHeaderExportData(parSkillArray:ArrayCollection):String
		{
			var locResult:String = "";
			
			for each (var locSkill:Skill in parSkillArray)
			{
				locResult += locSkill.name + ";";
			}
			
			locResult = locResult.substr(0, locResult.length - 1);
			locResult += '\n';
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui met les resultats du casting au format csv 
		 * @param void
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function exportCastingResult():void
		{
			var fileReference:FileReference = new FileReference();
			var text:ByteArray = new ByteArray();
			text.writeMultiByte(CONST_CASTING_FILE_HEADER + 
				buildCastingAssociationResult(), "latin9");
			fileReference.save(text, "GNK-Resultat_casting.csv");
		}
		
		/** DOCUMENTATION
		 * Fonction qui construit les resultats du casting au format csv 
		 * @param void
		 * @return String les resultats au format csv
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildCastingAssociationResult():String
		{
			var locResult:String = "";
			var i:int = 0;
			
			
			for each (var locCastingSession:CastingSession in CastingManager.getInstance().sessionArray)
			{
				i++;
				locResult += buildCastingAssociationExportData(i, locCastingSession);
			}
			
			return locResult;
		}
		
		/** DOCUMENTATION
		 * Fonction qui construit les résultats de l'association du casting au format csv 
		 * @param CastingSession la session de casting à analyser
		 * @return String les résultats au format csv
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildCastingAssociationExportData(parSessionNumber:int, parCastingSession:CastingSession):String
		{
			var locResult:String = "";
			
			for each (var locCastingAssociation:CastingAssociation in parCastingSession._sessionCastingAssociationArray)
			{
				locResult += parSessionNumber + ";";
				locResult += locCastingAssociation._playerCharacter.idName + ";";
				locResult += locCastingAssociation._humanPlayer.idName + ";";
				locResult += locCastingAssociation._performanceScore.toString() + ";";
				locResult += locCastingAssociation._skillPerformanceScore.toString() + ";";
				locResult += locCastingAssociation._playerChoiceCompatibilityScore.toString() + ";";
				locResult += locCastingAssociation._playWithCompatibilityScore.toString() + ";";
				locResult += locCastingAssociation._playWithoutCompatibilityScore.toString() + ";";
				locResult += locCastingAssociation._sessionWithCompatibilityScore.toString() + ";";
				locResult += locCastingAssociation._sessionWithoutCompatibilityScore.toString() + ";";
				locResult += locCastingAssociation._averageDeviationScore.toString() + "\n";
			}
			return locResult;
		}
	}
}