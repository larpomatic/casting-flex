package Model.CastingManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package CastingManager
	 * Le package CastingManager contient l'ensemble des models
	 * interagissant avec l'CastingManager. C'est le CastingManager
	 * qui va effectuer les différents appels aux algos du casting.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - CastingAssociationCalculator.as
	 * Fichier qui va calculer les écarts type des associations.
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	
	import Model.DataManager.DataManager;
	import Model.ToolBox.MathTools;
	
	import mx.collections.ArrayCollection;
	
	
	public class CastingAssociationCalculator
	{
		
		// Le personnage dont on calcul toutes les associations
		public var _playerCharacter:PlayerCharacter;
		// Les associations du personnages avec tout les joueurs
		public var _castingAssociationArray:ArrayCollection = new ArrayCollection();
		// La moyenne d'interprétation du personnage par l'ensemble des joueurs
		public var _mean:Number = 0.0;
		// L'ecart-type de l'interprétation des joueurs par rapport à la moyenne
		public var _stdDev:Number = 0.0;
		// Le score d'interprétation maximum du personnage par un joueur
		public var _max:Number = 0.0;
		
		
		/** DOCUMENTATION
		 * Constructeur de la classe CastingAssociationCalculator qui a partir
		 * d'un personnage construit l'intégralité de ses associations et calcul
		 * ses scores moyen et écart-type
		 * @Param PlayerCharacter Le personnage dont on va calculer les associations
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function CastingAssociationCalculator(parPlayerCharacter:PlayerCharacter)
		{
			_playerCharacter = parPlayerCharacter;
			trace("DEBUG [CAC]: Construction du CAC pour le personnage " + parPlayerCharacter.idName);
			_castingAssociationArray = buildCastingAssociationArray(parPlayerCharacter);
			var locScoreArray:ArrayCollection = buildScoreArray(_castingAssociationArray);
			_mean = MathTools.positiveMean(locScoreArray);
			_stdDev = MathTools.positiveStdDev(locScoreArray);
			_max = MathTools.maxInArray(locScoreArray);
			updateAverageDeviationScore(this);
			trace("----------------------------------------------------------------------------------------------");
			trace("DEBUG [CAC]: Moyenne " + this._mean);
			trace("DEBUG [CAC]: Ecart-type " + this._stdDev);
			trace("DEBUG [CAC]: Max " + this._max);
			trace("DEBUG [CAC]: Fin de construction du CAC pour le personnage " + parPlayerCharacter.idName);
			trace("----------------------------------------------------------------------------------------------");
			trace("");
			trace("----------------------------------------------------------------------------------------------");
		}
		
		/** DOCUMENTATION
		 * Fonction qui construit l'ensembles des associations possible pour un
		 * personnage (associé à tous les joueurs)
		 * @param PlayerCharacter Le personnage à associer
		 * @return Array La liste des association du personnage avec
		 * tout les joueurs
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function buildCastingAssociationArray(parPlayerCharacter:PlayerCharacter):ArrayCollection
		{
			var locDataManager:DataManager = DataManager.getInstance();
			var locHumanPlayerArray:ArrayCollection = locDataManager.humanPlayerArray;
			var locPlayerCastingAssociationArray:ArrayCollection = new ArrayCollection();
			
			for each (var locHumanPlayer:HumanPlayer in locHumanPlayerArray)
			{
				var locCastingAssociation:CastingAssociation = new CastingAssociation(parPlayerCharacter, locHumanPlayer);
				locPlayerCastingAssociationArray.addItem(locCastingAssociation);
			}
			
			return locPlayerCastingAssociationArray;
		}
		
		/** DOCUMENTATION
		 * Fonction qui mets à jour l'écart à la moyenne des casting
		 * association par rapport à la moyenne d'interprétation du
		 * personnage
		 * @param Number La moyenne d'interprétation du personnage
		 * @author Riyad YAKINE
		 * @since 2011/10/13
		 * */
		public function updateAverageDeviationScore(parCastingAssociationCalculator:CastingAssociationCalculator):void
		{	
			var locCastingAssociationArray:ArrayCollection = parCastingAssociationCalculator._castingAssociationArray;
			var locMeanScore:Number = parCastingAssociationCalculator._mean;
			
			for each (var locCastingAssociation:CastingAssociation in locCastingAssociationArray)
			{
				var locCastingAssociationPerformanceScore:Number = locCastingAssociation._performanceScore;
				var locAverageDeviationScore:Number = Math.abs(locMeanScore - locCastingAssociationPerformanceScore);
				
				locCastingAssociation._averageDeviationScore = locAverageDeviationScore;
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui récupère les scores de performances des association
		 * du personnage avec tout les joueurs
		 * @param Array La tableau des association
		 * @return Array Le tableau des scores
		 * @author Riyad YAKINE
		 * @since 2011/10/13
		 * */
		public function buildScoreArray(parCastingAssociationArray:ArrayCollection):ArrayCollection
		{	
			var locScoreArray:ArrayCollection = new ArrayCollection();
			
			for each (var locCastingAssociation:CastingAssociation in parCastingAssociationArray)
			{
				locScoreArray.addItem(locCastingAssociation._performanceScore);
			}
			
			return locScoreArray;
		}
	}
}