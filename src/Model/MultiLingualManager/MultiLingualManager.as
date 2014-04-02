package Model.MultiLingualManager {
import Model.ErrorManager.ErrorManager;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;

public class MultiLingualManager {
    // L'instance de la classe
    private static var _instance:MultiLingualManager;

    // La colonne de langue à lire
    private var _language:int;

    // Les éléments affichés ****************************

    // Le titre de l'application
    private var _applicationTitle:String;

    // Le texte du boutton pour lancer le casting
    [Bindable]
    public var runCastingButton:String;

    // Le texte du boutton pour selectionner l'algorithme à appliquer
    [Bindable]
    public var chooseAlgoButton:String;

    // Le texte du boutton pour choisir le nombre de session désirées
    [Bindable]
    public var chooseSessionNumberButton:String;

    // Le bouton d'importation d'un personnage
    [Bindable]
    public var importPersoButton:String;

    // Le bouton de telecharement de model
    [Bindable]
    public var downloadModelButton:String;

    // Le bouton pour exporter les personnages
    [Bindable]
    public var exportPersoButton:String;

    // Le bouton pour créer des personnages
    [Bindable]
    public var createPersoButton:String;

    // Le bouton d'importation d'un joueur
    [Bindable]
    public var importPlayerButton:String;

    // Le bouton pour exporter les joueurs
    [Bindable]
    public var exportPlayerButton:String;

    // Le bouton pour créer des joueurs
    [Bindable]
    public var createPlayerButton:String;

    // Le bouton pour exporter le resultat du casting
    [Bindable]
    public var exportCastingResultButton:String;

    // Le bouton pour aller sur le sondage
    [Bindable]
    public var linkToSondageButton:String;

    // Le bouton pour acceder au manuel utilisateur
    [Bindable]
    public var linkToManualButton:String;

    // Le texte de l'onglet de résultat du casting
    [Bindable]
    public var resultCastingOnglet:String;

    // Le texte de l'onglet des informations avancés
    [Bindable]
    public var advenceInfosOnglet:String;

    // Le texte de l'onglet du paramétrage avancé
    [Bindable]
    public var advenceSettingsOnglet:String;

    // Le texte de l'onglet des autres informations
    [Bindable]
    public var otherInfosOnglet:String;

    // Le texte jouer avec
    [Bindable]
    public var playWithLabel:String;

    // Le texte jouer sans
    [Bindable]
    public var playWithoutLabel:String;

    // Le texte dans meme session
    [Bindable]
    public var playInSameSessionLabel:String;

    // Le texte dans autre session
    [Bindable]
    public var playInOtherSessionLabel:String;

    // Le texte prenom
    [Bindable]
    public var firstNameLabel:String;

    // Le texte nom
    [Bindable]
    public var lastNameLabel:String;

    // Le texte sexe
    [Bindable]
    public var sexLabel:String;

    // Le texte competences
    [Bindable]
    public var competenciesLabel:String;

    // Le texte ajouter
    [Bindable]
    public var addLabel:String;

    // Le texte supprimer
    [Bindable]
    public var removeLabel:String;

    // Le texte homme
    [Bindable]
    public var manLabel:String;

    // Le texte femme
    [Bindable]
    public var womanLabel:String;

    // Le texte neutre
    [Bindable]
    public var neutreLabel:String;

    // Le texte valider
    [Bindable]
    public var validLabel:String;

    // Le texte annuler
    [Bindable]
    public var cancelLabel:String;

    // Le texte de l'onglet de gestion des caracteristiques
    [Bindable]
    public var caracteristicsManagerOnglet:String;

    // Le texte de l'onglet de gestion des relations
    [Bindable]
    public var relationshipManagerOnglet:String;

    // Le texte selectionner un personnage
    [Bindable]
    public var selectRoleLabel:String;

    // Le texte ecran modif un personnage
    [Bindable]
    public var screenRoleLabel:String;

    // Le texte ecran modif un joueur
    [Bindable]
    public var screenPlayerLabel:String;

    // Le texte de l'onglet de gestion des preferences du casting
    [Bindable]
    public var castingManagerOnglet:String;

    // Le texte selectionner un joueur
    [Bindable]
    public var selectPlayerLabel:String;

    // Le texte param algo
    [Bindable]
    public var algoSettingLabel:String;

    // Le texte param relation
    [Bindable]
    public var relationshipPonderationLabel:String;

    // Le texte param competence
    [Bindable]
    public var competenciesPonderationLabel:String;

    // Le texte informations
    [Bindable]
    public var informationLabel:String;

    // Le texte facultatif
    [Bindable]
    public var facultatifLabel:String;

    // Le texte interprete
    [Bindable]
    public var interpreteLabel:String;

    // Le texte to not interprete
    [Bindable]
    public var notInterpreteLabel:String;

    // Le texte de advance setting
    [Bindable]
    public var sevenBestBoyCast:String;

    // Le texte de advance setting
    [Bindable]
    public var sevenBestGirlCast:String;

    // Le texte de advance setting
    [Bindable]
    public var sevenWorstBoyCast:String;

    // Le texte de advance setting
    [Bindable]
    public var sevenWorstGirlCast:String;

    // Le texte de advance setting
    [Bindable]
    public var scoreMoyenCast:String;

    // Le texte de advance setting
    [Bindable]
    public var scoreMoyenBoyCast:String;

    // Le texte de advance setting
    [Bindable]
    public var scoreMoyenGirlCast:String;

    // **************************************************

    // Mon lecteur de fichier
    private var _textLoader:URLLoader = new URLLoader();

    // Ma liste d'élément lu
    private var _elementsToShow:ArrayCollection = new ArrayCollection();

    public function MultiLingualManager() {
        changeLanguage("fr_FR");
    }

    public static function getInstance():MultiLingualManager {
        if (_instance == null) {
            _instance = new MultiLingualManager();
        }

        return _instance;
    }

    // Les getters *****************************************

    public function get applicationTitle():String {
        return _applicationTitle;
    }

    // *****************************************************
    public function changeLanguage(language:String):void {
        // Langue française?
        if (language == "fr_FR") {
            showFrenchApplication();
        }
        else if (language == "en_US") {
            showEnglishApplication();
        }
    }

    private function onLoadCompleted(e:Event):void {
//			ErrorManager.getInstance().addImportErrorMessage("start test");			

        var myArrayOfLines:Array = e.target.data.split('\n');

//			ErrorManager.getInstance().addImportErrorMessage(myArrayOfLines.length.toString());

        var myArrayOfWords:ArrayCollection = new ArrayCollection();

        _elementsToShow = new ArrayCollection();


        for (var num:int = 1; myArrayOfLines != null && num < myArrayOfLines.length; ++num) {
            var contents:Array = myArrayOfLines[num].split(';');

//				for (var i:int = _language; contents != null && i < contents.length; i = i + 2)
//				{
//					ErrorManager.getInstance().addImportErrorMessage(contents[i]);

            _elementsToShow.addItem(contents[_language]);
//				}

        }

        _applicationTitle = _elementsToShow[0];
        runCastingButton = _elementsToShow[1];
        chooseAlgoButton = _elementsToShow[2];
        chooseSessionNumberButton = _elementsToShow[3];
        importPersoButton = _elementsToShow[4];
        downloadModelButton = _elementsToShow[5];
        createPersoButton = _elementsToShow[6];
        exportPersoButton = _elementsToShow[7];
        importPlayerButton = _elementsToShow[8];
        createPlayerButton = _elementsToShow[9];
        exportPlayerButton = _elementsToShow[10];
        exportCastingResultButton = _elementsToShow[11];
        linkToSondageButton = _elementsToShow[12];
        linkToManualButton = _elementsToShow[13];
        resultCastingOnglet = _elementsToShow[14];
        advenceInfosOnglet = _elementsToShow[15];
        advenceSettingsOnglet = _elementsToShow[16];
        otherInfosOnglet = _elementsToShow[17];
        playWithLabel = _elementsToShow[18];
        playWithoutLabel = _elementsToShow[19];
        playInSameSessionLabel = _elementsToShow[20];
        playInOtherSessionLabel = _elementsToShow[21];
        firstNameLabel = _elementsToShow[22];
        lastNameLabel = _elementsToShow[23];
        sexLabel = _elementsToShow[24];
        competenciesLabel = _elementsToShow[25];
        addLabel = _elementsToShow[26];
        removeLabel = _elementsToShow[27];
        manLabel = _elementsToShow[28];
        womanLabel = _elementsToShow[29];
        neutreLabel = _elementsToShow[30];
        validLabel = _elementsToShow[31];
        cancelLabel = _elementsToShow[32];
        caracteristicsManagerOnglet = _elementsToShow[33];
        relationshipManagerOnglet = _elementsToShow[34];
        selectRoleLabel = _elementsToShow[35];
        screenRoleLabel = _elementsToShow[36];
        screenPlayerLabel = _elementsToShow[37];
        castingManagerOnglet = _elementsToShow[38];
        selectPlayerLabel = _elementsToShow[39];
        algoSettingLabel = _elementsToShow[40];
        relationshipPonderationLabel = _elementsToShow[41];
        competenciesPonderationLabel = _elementsToShow[42];
        informationLabel = _elementsToShow[43];
        facultatifLabel = _elementsToShow[44];
        interpreteLabel = _elementsToShow[45];
        notInterpreteLabel = _elementsToShow[46];
        sevenBestBoyCast = _elementsToShow[47];
        sevenBestGirlCast = _elementsToShow[48];
        sevenWorstBoyCast = _elementsToShow[49];
        sevenWorstGirlCast = _elementsToShow[50];
        scoreMoyenCast = _elementsToShow[51];
        scoreMoyenBoyCast = _elementsToShow[52];
        scoreMoyenGirlCast = _elementsToShow[53];
    }

    private function showFrenchApplication():void {
        configureListeners(_textLoader);

        try {
            _language = 1;

            var myRequest:URLRequest = new URLRequest("language.csv");

            _textLoader.load(myRequest);
        }
        catch (e:Error) {
            ErrorManager.getInstance().addImportErrorMessage("Error loading language file");
            ErrorManager.getInstance().addImportErrorMessage(e.toString());
        }
    }

    private function showEnglishApplication():void {
        configureListeners(_textLoader);

        try {
            _language = 2;

            var myRequest:URLRequest = new URLRequest("language.csv");

            _textLoader.load(myRequest);
        }
        catch (e:Error) {
            ErrorManager.getInstance().addImportErrorMessage("Error loading language file");
            ErrorManager.getInstance().addImportErrorMessage(e.toString());
        }
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.COMPLETE, onLoadCompleted);
    }
}
}