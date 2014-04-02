package Model.CastingManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package CastingManager
	 * Le package CastingManager contient l'ensemble des models
	 * interagissant avec l'CastingManager. C'est le CastingManager
	 * qui va effectuer les différents appels aux algos d'association
	 * du casting.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - CastingAssociation.as
	 * C'est ce fichier qui va contenir le résultats des
	 * différents appels au algos de casting.
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	import DataObjects.Skill;
	
	import Model.AlgoManager.AlgoManager;
	import Model.AlgoManager.AlgoParam;
	import Model.DataManager.DataManager;
	import Model.ToolBox.CastingAlgoTools;
	import Model.ToolBox.MathTools;
	
	import mx.collections.ArrayCollection;
	

	public class CastingAssociation
	{
		// Le personnage à interpréter
		[Bindable]
		public var _playerCharacter:PlayerCharacter = null;
		// Le joueur interprétant le personnage
		[Bindable]
		public var _humanPlayer:HumanPlayer = null;
		// Le score d'interprétation générale du personnage par le joueur
		// Moyenne du score de compétences et du score de désirs
		[Bindable]
		public var _performanceScore:Number = 0.0;
		// Le score de compatibilité des compétences du joueur avec le personnage
		// Moyenne de ses scores de compatibilités de skills
		[Bindable]
		public var _skillPerformanceScore:Number = 0.0;
		// Le score de compatibilité des désirs du joueur par rapport au reste du casting
		// Moyenne de ses scores de désirs
		[Bindable]
		public var _playerChoiceCompatibilityScore:Number = 0.0;
		// Score de compatibilité de désir de joue avec
		[Bindable]
		public var _playWithCompatibilityScore:Number = 0.0;
		// Score de compatibilité de désir de joue avec OBLIGATOIRE
		[Bindable]
		public var _playWithMendatoryCompatibilityScore:Number = 0.0;
		// Score de compatibilité de désir de joue sans
		[Bindable]
		public var _playWithoutCompatibilityScore:Number = 0.0;
		// Score de compatibilité de désir de session avec
		[Bindable]
		public var _sessionWithCompatibilityScore:Number = 0.0;
		// Score de compatibilité de désir de session sans
		[Bindable]
		public var _sessionWithoutCompatibilityScore:Number = 0.0;
		// L'écart à la moyenne d'interprétation du personnage (en absolu)
		[Bindable]
		public var _averageDeviationScore:Number = 0.0;
		// Si l'association est fixé par l'utilisateur
		// Ce paramètre est binder à la checkbox de l'association
		public var _locked:Boolean = false;
		// Le score quand le joueur n'a aucune préférence
		private var _scoreNoPreference:Number = 100.0;
		
		
		// Constructeur prenant un personnage et un joueur afin de calculer 
		// l'ensemble des scores de l'asssociation
		/** DOCUMENTATION
		 * Constructeur de la classe CastingAssociation qui a partir d'un 
		 * personnage et d'un joueur calcul l'ensemble des scores
		 * @Param PlayerCharacter Le personnage de l'association
		 * @Param HumanPlayer Le joueur de l'association
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function CastingAssociation(parPlayerCharacter:PlayerCharacter,
											parHumanPlayer:HumanPlayer)
		{
			_playerCharacter = parPlayerCharacter;
			_humanPlayer = parHumanPlayer;
			computePerformanceScore(this);
			trace("DEBUG [CA]: Construction de l'association personnage/joueur: " +
				parPlayerCharacter.idName + "/" + parHumanPlayer.idName +
				" = " + this._performanceScore);
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le score d'interprétation d'une association personnage/joueur
		 * @since 2011/10/04
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * */
		private function computePerformanceScore(parCastingAssociation:CastingAssociation):void
		{
			// Appels aux fonctions calculant le la compatibilité des skills et des choix du joueur
			computeSkillPerformanceScore(parCastingAssociation);
			computePlayerChoiceCompatibilityScore(parCastingAssociation);
			
			// Récupération des scores de compatibilité
			var locScoreArray:ArrayCollection = new ArrayCollection();
			locScoreArray.addItem(parCastingAssociation._skillPerformanceScore);
			locScoreArray.addItem(parCastingAssociation._playerChoiceCompatibilityScore);
			
			// Moyenne des scores de compatibilité positif (pour ne pas fausser la moyenne)
			if (AlgoManager.getInstance()._eqBetweenCompetencyAndRelation == 50)
			{
				parCastingAssociation._performanceScore = MathTools.positiveMean(locScoreArray);
			}
			else
			{
				// Prend en compte le parametrage d'importance par l'utilisateur
				var locImportanceCompetency:Number = (100 - AlgoManager.getInstance()._eqBetweenCompetencyAndRelation) / 100;
				var locImportanceRelation:Number = ((AlgoManager.getInstance()._eqBetweenCompetencyAndRelation) / 100);
				var locSkillPerformanceScore:Number = parCastingAssociation._skillPerformanceScore * locImportanceCompetency;
				var locPlayerChoiceCopatibilityScore:Number = parCastingAssociation._playerChoiceCompatibilityScore * locImportanceRelation;
				
				// Vérification de la positivité
				if (locSkillPerformanceScore < 0)
				{
					locSkillPerformanceScore = 0;
				}
				if (locPlayerChoiceCopatibilityScore < 0)
				{
					locPlayerChoiceCopatibilityScore = 0;
				}
				
				parCastingAssociation._performanceScore = locSkillPerformanceScore + locPlayerChoiceCopatibilityScore; 
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le score d'interprétation de compétences du personnage par le joueur (en %)
		 * Tester et valider le 2011/05/11
		 * @since 2011/05/11
		 * @lastModif 2011/04/30
		 * @author Mickael Lebon
		 * @param CastingAssociation L'association personnage/joueur
		 */
		private function computeSkillPerformanceScore(parCastingAssociation:CastingAssociation):void
		{
			// Récupération des skills du personnage et du joueurs
			var locPCSkillArray:ArrayCollection = parCastingAssociation._playerCharacter.skillArray;
			var locHPSkillArray:ArrayCollection = parCastingAssociation._humanPlayer.skillArray;
			// Variable nécessaire pour la boucle de parcours du tableau de skill
			var locArraySize:int = locHPSkillArray.length;
			var i:int = 0;
			// Tableau qui va stocker les écarts entre le skill personnage et joueur
			var locDeltaSkillArray:ArrayCollection = new ArrayCollection();
			// Récupération du critère discriminant sexe
			var locSexCriteria:Boolean = AlgoParam.getInstance().sexCriteria;
			
			// Vérification du sexe
			if (locSexCriteria && CastingAlgoTools.isNotSameSex(parCastingAssociation))
			{
				// Le sexe doit être le même or il est différent donc le score est a -100 (impossibilité d'interpréter)
				parCastingAssociation._skillPerformanceScore = -100.0;
			}
			else
			{
				// Le critère de sexe n'est pas discriminant ou bien joueur et personnage partage le même sexe
				// Parcours du tableau de skill
				for (i; i < locArraySize; i++)
				{
					// Récupérations des scores pour le skill courant
					var locTmpPCSkillCapacity:int = 0;
					var locTmpHPSkillCapacity:int = 0;
					locTmpPCSkillCapacity = (locPCSkillArray[i] as Skill).capacity;
					locTmpHPSkillCapacity = (locHPSkillArray[i] as Skill).capacity;
					
					// Récupération de l'écart pour le skill courant
					var locTmpDeltaSkillNum:int = 0;
					var locTmpDeltaSkillDenum:int = 0;
					var locTmpDeltaSkill:Number = 0.0;
					locTmpDeltaSkillNum = Math.abs(locTmpPCSkillCapacity - locTmpHPSkillCapacity);
					locTmpDeltaSkillDenum = Math.max(locTmpPCSkillCapacity, locTmpHPSkillCapacity);
					// Récupération de la compatibilité en pourcentage (1 - écart) * 100
					locTmpDeltaSkill = (1 - (locTmpDeltaSkillNum / locTmpDeltaSkillDenum)) * 100;
					
					// Ajout de l'écart au tableau d'écart
					locDeltaSkillArray.addItem(locTmpDeltaSkill);
				}
				
				// Stockage du score d'interprétation des skills du personnage par le joueur
				if (AlgoParam.getInstance().ponderationCriteria == false)
				{
					// Normalement
					parCastingAssociation._skillPerformanceScore = MathTools.mean(locDeltaSkillArray);
				}
				else
				{
					// Avec ponderation
					parCastingAssociation._skillPerformanceScore = MathTools.meanWithPonderation(locDeltaSkillArray);
				}
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le score de respect du désir d'un joueur dans une association
		 * personnage/joueur
		 * @since 2011/10/04
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * */
		private function computePlayerChoiceCompatibilityScore(parCastingAssociation:CastingAssociation):void
		{
			// Appels aux fonctions calculant le respect des choix du joueur
			computePlayWithCompatibilityScore(parCastingAssociation);
			computePlayWithMendatryCompatibilityScore(parCastingAssociation);			
			computePlayWithoutCompatibilityScore(parCastingAssociation);
			computeSessionWithCompatibilityScore(parCastingAssociation);
			computeSessionWithoutCompatibilityScore(parCastingAssociation);
			
			// Vérification du 'play with Mendatory'
			if (parCastingAssociation._playWithMendatoryCompatibilityScore != _scoreNoPreference)
			{
				parCastingAssociation._playWithCompatibilityScore = parCastingAssociation._playWithMendatoryCompatibilityScore;
			}
			
			// Récupération des scores de respect des choix du joueur
			var locPlayerChoiceScoreArray:ArrayCollection = new ArrayCollection();
			locPlayerChoiceScoreArray.addItem(parCastingAssociation._playWithCompatibilityScore);
			locPlayerChoiceScoreArray.addItem(parCastingAssociation._playWithMendatoryCompatibilityScore);
			locPlayerChoiceScoreArray.addItem(parCastingAssociation._playWithoutCompatibilityScore);
			locPlayerChoiceScoreArray.addItem(parCastingAssociation._sessionWithCompatibilityScore);
			locPlayerChoiceScoreArray.addItem(parCastingAssociation._sessionWithoutCompatibilityScore);
			
			// Moyenne des scores positif de respect des choix du joueur (afin de ne pas fausser la moyenne)
			parCastingAssociation._playerChoiceCompatibilityScore = MathTools.positiveMean(locPlayerChoiceScoreArray);
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le respect du désir de joue avec d'un joueur
		 * @since 2011/10/04
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * */
		private function computePlayWithCompatibilityScore(parCastingAssociation:CastingAssociation):void
		{
			// Récupération du nombre de joueurs - le joueur courant (car deja associé) afin de
			// calculer le nombre d'arrangement possible
			var locHPArraySize:int = DataManager.getInstance().humanPlayerArray.length - 1;
			// Récupération du nombres de joue avec du personnage et du joueur
			var locPCPlayWithArraySize:int = parCastingAssociation._playerCharacter.playWithArray.length;
			var locHPPlayWithArraySize:int = parCastingAssociation._humanPlayer.playWithArray.length;
			// Récupération des résultats de compatibilité
			var locHPPlayWithPermutation:int;
			var locHPPermutationPossibilities:int;
			// Récupération du critère discriminant sexe
			var locSexCriteria:Boolean = AlgoParam.getInstance().sexCriteria;
			
			// Vérification du sexe
			if (locSexCriteria && CastingAlgoTools.isNotSameSex(parCastingAssociation)){
				// Le sexe doit être le même or il est différent donc le score est a -100 (impossibilité d'interpréter)
				parCastingAssociation._playWithCompatibilityScore = -100.0;
			} else {
				// Le critère de sexe n'est pas discriminant ou bien joueur et personnage partage le même sexe
				if (locHPPlayWithArraySize == 0) {
					// Aucun choix du joueur donc n'importe quel choix lui conviendra
					parCastingAssociation._playWithCompatibilityScore = _scoreNoPreference;
				} else {
					if (locHPPlayWithArraySize > locPCPlayWithArraySize) {
						// Le personnage n'a pas suffisament de propositions pour répondre aux demandes du joueur (N parmi N)
						locHPPlayWithPermutation = MathTools.permutation(locPCPlayWithArraySize,locPCPlayWithArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPPlayWithArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._playWithCompatibilityScore = (locHPPlayWithPermutation /
							locHPPermutationPossibilities) * 100;
					} else {
						// Le personnage a suffisament de propositions pour répondre aux demandes du joueur (K parmi N)
						locHPPlayWithPermutation = MathTools.permutation(locHPPlayWithArraySize,locPCPlayWithArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPPlayWithArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._playWithCompatibilityScore = (locHPPlayWithPermutation /
							locHPPermutationPossibilities) * 100;
					}
				}
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le respect du désir obligatoirement jouer avec un autre joueur
		 * @since 2012/10/16
		 * @author Mickael LEBON
		 * @param CastingAssociation L'association personnage/joueur
		 * */
		private function computePlayWithMendatryCompatibilityScore(parCastingAssociation:CastingAssociation):void
		{
			// Récupération du nombre de joueurs - le joueur courant (car deja associé) afin de
			// calculer le nombre d'arrangement possible
			var locHPArraySize:int = DataManager.getInstance().humanPlayerArray.length - 1;
			// Récupération du nombres de joue avec du personnage et du joueur
			var locPCPlayWithArraySize:int = parCastingAssociation._playerCharacter.playWithArray.length;
			var locHPPlayWithArraySize:int = parCastingAssociation._humanPlayer.playWithMendatoryArray.length;
			// Récupération des résultats de compatibilité
			var locHPPlayWithPermutation:int;
			var locHPPermutationPossibilities:int;
			// Récupération du critère discriminant sexe
			var locSexCriteria:Boolean = AlgoParam.getInstance().sexCriteria;
			
			// Vérification du sexe
			if (locSexCriteria && CastingAlgoTools.isNotSameSex(parCastingAssociation))
			{
				// Le sexe doit être le même or il est différent donc le score est a -100 (impossibilité d'interpréter)
				parCastingAssociation._playWithMendatoryCompatibilityScore = -100.0;
			}
			else
			{
				// Le critère de sexe n'est pas discriminant ou bien joueur et personnage partage le même sexe
				if (locHPPlayWithArraySize == 0)
				{
					// Aucun choix du joueur donc n'importe quel choix lui conviendra
					parCastingAssociation._playWithMendatoryCompatibilityScore = _scoreNoPreference;
				}
				else
				{
					if (locHPPlayWithArraySize > locPCPlayWithArraySize)
					{
						// Le personnage n'a pas suffisament de propositions pour répondre aux demandes du joueur (N parmi N)
						locHPPlayWithPermutation = MathTools.permutation(locPCPlayWithArraySize,locPCPlayWithArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPPlayWithArraySize, locHPArraySize);
						
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._playWithMendatoryCompatibilityScore = (locHPPlayWithPermutation /
							locHPPermutationPossibilities) * 100;
					}
					else
					{
						// Le personnage a suffisament de propositions pour répondre aux demandes du joueur (K parmi N)
						locHPPlayWithPermutation = MathTools.permutation(locHPPlayWithArraySize,locPCPlayWithArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPPlayWithArraySize, locHPArraySize);
						
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._playWithMendatoryCompatibilityScore = (locHPPlayWithPermutation /
							locHPPermutationPossibilities) * 100;
					}
				}
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le respect du désir de joue sans d'un joueur
		 * @since 2011/10/04
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * */
		private function computePlayWithoutCompatibilityScore(parCastingAssociation:CastingAssociation):void
		{
			// Récupération du nombre de joueurs - le joueur courant (car deja associé) afin de
			// calculer le nombre d'arrangement possible
			var locHPArraySize:int = DataManager.getInstance().humanPlayerArray.length - 1;
			// Récupération du nombres de joue sans du personnage et du joueur
			var locPCPlayWithoutArraySize:int = parCastingAssociation._playerCharacter.playWithoutArray.length;
			var locHPPlayWithoutArraySize:int = parCastingAssociation._humanPlayer.playWhitoutArray.length;
			// Récupération des résultats de compatibilité
			var locHPPlayWithoutPermutation:int;
			var locHPPermutationPossibilities:int;
			// Récupération du critère discriminant sexe
			var locSexCriteria:Boolean = AlgoParam.getInstance().sexCriteria;
			
			// Vérification du sexe
			if (locSexCriteria && CastingAlgoTools.isNotSameSex(parCastingAssociation)){
				// Le sexe doit être le même or il est différent donc le score est a -100 (impossibilité d'interpréter)
				parCastingAssociation._playWithoutCompatibilityScore = -100.0;
			} else {
				// Le critère de sexe n'est pas discriminant ou bien joueur et personnage partage le même sexe
				if (locHPPlayWithoutArraySize == 0) {
					// Aucun choix du joueur donc n'importe quel choix lui conviendra
					parCastingAssociation._playWithoutCompatibilityScore = _scoreNoPreference;
				} else {
					if (locHPPlayWithoutArraySize > locPCPlayWithoutArraySize) {
						// Le personnage n'a pas suffisament de propositions pour répondre aux demandes du joueur (N parmi N)
						locHPPlayWithoutPermutation = MathTools.permutation(locPCPlayWithoutArraySize,locPCPlayWithoutArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPPlayWithoutArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._playWithoutCompatibilityScore = (locHPPlayWithoutPermutation /
							locHPPermutationPossibilities) * 100;
					} else {
						// Le personnage a suffisament de propositions pour répondre aux demandes du joueur (K parmi N)
						locHPPlayWithoutPermutation = MathTools.permutation(locHPPlayWithoutArraySize,locPCPlayWithoutArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPPlayWithoutArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._playWithCompatibilityScore = (locHPPlayWithoutPermutation /
							locHPPermutationPossibilities) * 100;
					}
				}
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le respect du désir de session avec d'un joueur
		 * @since 2011/10/04
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * */
		private function computeSessionWithCompatibilityScore(parCastingAssociation:CastingAssociation):void
		{
			// Récupération du nombre de joueurs - le joueur courant (car deja associé) afin de
			// calculer le nombre d'arrangement possible
			var locHPArraySize:int = DataManager.getInstance().humanPlayerArray.length - 1;
			// Récupération du nombre de personnages - le personnage courant (car deja associé) afin de
			// calculer le nombre d'arrangement possible
			var locPCArraySize:int = DataManager.getInstance().playerCharacterArray.length - 1;
			// Récupération du nombres de session avec du joueur
			var locHPSessionWithArraySize:int = parCastingAssociation._humanPlayer.inSameSessionArray.length;
			// Récupération des résultats de compatibilité
			var locHPSessionWithPermutation:int;
			var locHPPermutationPossibilities:int;
			// Récupération du critère discriminant sexe
			var locSexCriteria:Boolean = AlgoParam.getInstance().sexCriteria;
			
			// Vérification du sexe
			if (locSexCriteria && CastingAlgoTools.isNotSameSex(parCastingAssociation)){
				// Le sexe doit être le même or il est différent donc le score est a -100 (impossibilité d'interpréter)
				parCastingAssociation._sessionWithCompatibilityScore = -100.0;
			} else {
				// Le critère de sexe n'est pas discriminant ou bien joueur et personnage partage le même sexe
				if (locHPSessionWithArraySize == 0) {
					// Aucun choix du joueur donc n'importe quel choix lui conviendra
					parCastingAssociation._sessionWithCompatibilityScore = _scoreNoPreference;
				} else {
					if (locHPSessionWithArraySize > locPCArraySize) {
						// La session ne contient pas suffisament de personnages pour répondre aux demandes du joueur (N parmi N)
						locHPSessionWithPermutation = MathTools.permutation(locPCArraySize,locPCArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPSessionWithArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._sessionWithCompatibilityScore = (locHPSessionWithPermutation /
							locHPPermutationPossibilities) * 100;
					} else {
						// La session contient suffisament de personnages pour répondre aux demandes du joueur (K parmi N)
						locHPSessionWithPermutation = MathTools.permutation(locHPSessionWithArraySize, locPCArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPSessionWithArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._sessionWithCompatibilityScore = (locHPSessionWithPermutation /
							locHPPermutationPossibilities) * 100;
					}
				}
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule le respect du désir de session sans d'un joueur
		 * @since 2011/10/04
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * */
		private function computeSessionWithoutCompatibilityScore(parCastingAssociation:CastingAssociation):void
		{
			// Récupération du nombre de joueurs - le joueur courant (car deja associé) afin de
			// calculer le nombre d'arrangement possible
			var locHPArraySize:int = DataManager.getInstance().humanPlayerArray.length - 1;
			// Récupération du nombre de personnages - le personnage courant (car deja associé) afin de
			// calculer le nombre d'arrangement possible
			var locPCArraySize:int = DataManager.getInstance().playerCharacterArray.length - 1;
			// Récupération du nombres de session sans du joueur
			var locHPSessionWithoutArraySize:int = parCastingAssociation._humanPlayer.inOtherSessionArray.length;
			// Récupération des résultats de compatibilité
			var locHPSessionWithoutPermutation:int;
			var locHPPermutationPossibilities:int;
			// Récupération du critère discriminant sexe
			var locSexCriteria:Boolean = AlgoParam.getInstance().sexCriteria;
			
			// Vérification du sexe
			if (locSexCriteria && CastingAlgoTools.isNotSameSex(parCastingAssociation)){
				// Le sexe doit être le même or il est différent donc le score est a -100 (impossibilité d'interpréter)
				parCastingAssociation._sessionWithoutCompatibilityScore = -100.0;
			} else {
				// Le critère de sexe n'est pas discriminant ou bien joueur et personnage partage le même sexe
				if (locHPSessionWithoutArraySize == 0) {
					// Aucun choix du joueur donc n'importe quel choix lui conviendra
					parCastingAssociation._sessionWithoutCompatibilityScore = _scoreNoPreference;
				} else {
					if (locHPSessionWithoutArraySize > locPCArraySize) {
						// La session ne contient pas suffisament de personnages pour répondre aux demandes du joueur (N parmi N)
						locHPSessionWithoutPermutation = MathTools.permutation(locPCArraySize,locPCArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPSessionWithoutArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._sessionWithoutCompatibilityScore = (locHPSessionWithoutPermutation /
							locHPPermutationPossibilities) * 100;
					} else {
						// La session contient suffisament de personnages pour répondre aux demandes du joueur (K parmi N)
						locHPSessionWithoutPermutation = MathTools.permutation(locHPSessionWithoutArraySize, locPCArraySize);
						locHPPermutationPossibilities = MathTools.permutation(locHPSessionWithoutArraySize, locHPArraySize);
						// Calcul du pourcentage de compatibilité
						parCastingAssociation._sessionWithoutCompatibilityScore = (locHPSessionWithoutPermutation /
							locHPPermutationPossibilities) * 100;
					}
				}
			}
		}
	}
}