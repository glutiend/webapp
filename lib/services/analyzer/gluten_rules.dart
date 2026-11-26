// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

class GlutenRules {
  static const List<String> dangerKeywords = [
    // Italiano
    "frumento", "grano", "orzo", "segale", "farro", "kamut",
    "spelta", "glutine", "tritordeum", "couscous", "bulgur", "seitan",
    // Inglese
    "wheat", "barley", "rye", "spelt", "gluten", "semolina", "triticale",
    // Francese
    "blé", "froment", "orge", "seigle", "épeautre",
    // Spagnolo
    "trigo", "cebada", "centeno", "espelta",
    // Tedesco
    "weizen", "gerste", "roggen", "dinkel",
    // Portoghese
    "cevada", "centeio",
    // Olandese
    "tarwe", "gerst", "rogge",
    // Polacco
    "pszenica", "jęczmień", "żyto", "orkisz",
    // Turco
    "buğday", "arpa", "çavdar",
    // Russo
    "пшеница", "ячмень", "рожь", "глютен",
    // Svedese
    "vete", "korn", "råg",
    // Danese/Norvegese
    "hvede", "byg", "rug", "hvete",
    // Ceco
    "pšenice", "ječmen", "žito",
    // Romeno
    "grâu", "orz", "secară",
    // Ungherese
    "búza", "árpa", "rozs",
    // Croato
    "pšenica", "ječam", "raž",
    // Greco
    "σιτάρι", "κριθάρι", "σίκαλη", "γλουτένη",
    // Arabo
    "قمح", "شعير", "غلوتين",
    // Giapponese
    "小麦", "大麦", "ライ麦", "グルテン",
  ];

  static const List<String> maltoKeywords = [
    "malto",
    "malt",
    "maltosio",
    "maltose",
    "malz",
  ];

  static const List<String> barleyMaltPhrases = [
    // Italiano
    "estratto di malto d'orzo",
    "estratto di malto di orzo",
    "estratto di malto d’orzo",
    "estratto di malto",
    "malto d'orzo",
    "malto di orzo",
    "malto d’orzo",
    "aroma di malto d'orzo",
    "aroma di malto d’orzo",
    "aromi di malto d'orzo",
    "aromi di malto d’orzo",
    "aroma di malto",
    "aromi di malto",
    // Inglese
    "barley malt extract",
    "barley malt",
    "malt extract (barley)",
    "extract of barley malt",
    "barley malt flavouring",
    "barley malt flavoring",
    // Francese
    "extrait de malt d'orge",
    "extrait de malt d’orge",
    "malt d'orge",
    "malt d’orge",
    // Spagnolo
    "extracto de malta de cebada",
    "malta de cebada",
    // Tedesco
    "gerstenmalzextrakt",
    "gerstenmalz",
    // Olandese
    "gerstemoutextract",
    "gerstemout",
  ];

  /// Restituisce `true` se la parola 'orzo' (o equivalenti traduzioni) compare
  /// ESCLUSIVAMENTE all'interno di frasi relative ad estratto di malto d'orzo / aromi di malto.
  /// Se compare anche come cereale a sé (es. 'farina d'orzo', 'orzo perlato'), restituisce `false`.
  static bool isBarleyOnlyFromMalt(String text) {
    String sanitized = text.toLowerCase();
    for (final phrase in barleyMaltPhrases) {
      sanitized = sanitized.replaceAll(phrase, " ");
    }
    sanitized = sanitized.replaceAll("’", "'");
    final regex = RegExp(
      r"\b(orzo|barley|orge|cebada|gerste|gerst)\b",
      caseSensitive: false,
    );
    return !regex.hasMatch(sanitized);
  }

  static const List<String> traceKeywords = [
    // Italiano
    "può contenere tracce di cereali contenenti glutine",
    "può contenere tracce di cereali con glutine",
    "può contenere tracce di frumento",
    "può contenere tracce di glutine",
    "può contenere tracce di grano",
    "può contenere tracce di cereali",
    "può contenere tracce di orzo",
    "può contenere tracce di farro",
    "può contenere tracce di segale",
    "può contenere tracce di avena",
    "può contenere cereali contenenti glutine",
    "può contenere glutine",
    "può contenere frumento",
    "può contenere grano",
    "può contenere orzo",
    "può contenere farro",
    "può contenere segale",
    "contiene tracce di glutine",
    "contiene tracce di frumento",
    "tracce di cereali contenenti glutine",
    "tracce di glutine",
    "tracce di frumento",
    "tracce di grano",
    "tracce di cereali",
    "tracce di orzo",
    "tracce di farro",
    "tracce di segale",
    "stabilimento che lavora anche frumento",
    "stabilimento che lavora anche glutine",
    "stabilimento che lavora anche cereali",
    "stabilimento che utilizza cereali contenenti glutine",
    "stabilimento che utilizza cereali con glutine",
    "lavorato in uno stabilimento che utilizza glutine",
    "lavorato in uno stabilimento che utilizza frumento",

    // Inglese
    "may contain traces of cereals containing gluten",
    "may contain traces of gluten",
    "may contain traces of wheat",
    "may contain traces of barley",
    "may contain traces of rye",
    "may contain traces of cereals",
    "may contain cereals containing gluten",
    "may contain gluten",
    "may contain wheat",
    "may contain barley",
    "may contain rye",
    "contains traces of gluten",
    "contains traces of wheat",
    "traces of cereals containing gluten",
    "traces of gluten",
    "traces of wheat",
    "traces of barley",
    "traces of rye",
    "made in a facility that also processes wheat",
    "made in a facility that also processes gluten",
    "packaged in a facility that also handles wheat",
    "packaged in a facility that also handles gluten",

    // Francese
    "peut contenir des traces de céréales contenant du gluten",
    "peut contenir des traces de gluten",
    "peut contenir des traces de blé",
    "peut contenir des traces d'orge",
    "peut contenir des traces de seigle",
    "traces de céréales contenant du gluten",
    "traces de gluten",
    "traces de blé",
    "traces d'orge",
    "traces de seigle",
    "peut contenir du gluten",
    "peut contenir du blé",
    "peut contenir de l'orge",
    "peut contenir du seigle",
    "peut contenir gluten",
    "peut contenir blé",
    "peut contenir orge",
    "peut contenir seigle",
    "fabriqué dans un atelier qui utilise du gluten",
    "fabriqué dans un atelier qui utilise du blé",

    // Spagnolo
    "puede contener trazas de cereales que contengan gluten",
    "puede contener trazas de gluten",
    "puede contener trazas de trigo",
    "puede contener trazas de cebada",
    "puede contener trazas de centeno",
    "trazas de cereales con gluten",
    "trazas de gluten",
    "trazas de trigo",
    "trazas de cebada",
    "trazas de centeno",
    "puede contener gluten",
    "puede contener trigo",
    "puede contener cebada",
    "puede contener centeno",
    "elaborado en una fábrica que utiliza gluten",
    "elaborado en instalaciones que procesan trigo",

    // Tedesco
    "kann spuren von glutenhaltigem getreide enthalten",
    "kann spuren von gluten enthalten",
    "kann spuren von weizen enthalten",
    "kann spuren von gerste enthalten",
    "kann spuren von roggen enthalten",
    "spuren von gluten",
    "spuren von weizen",
    "spuren von gerste",
    "spuren von roggen",
    "kann gluten enthalten",
    "kann weizen enthalten",
    "kann gerste enthalten",
    "kann roggen enthalten",
    "kann enthalten gluten",
    "kann enthalten weizen",
    "kann enthalten gerste",
    "kann enthalten roggen",
    "in einem betrieb hergestellt, der auch gluten verarbeitet",
    "in einem betrieb hergestellt, der auch weizen verarbeitet",

    // Portoghese
    "pode conter vestígios de cereais que contêm glúten",
    "pode conter vestígios de glúten",
    "pode conter vestígios de trigo",
    "pode conter vestígios de cevada",
    "pode conter traços de glúten",
    "pode conter traços de trigo",
    "pode conter traços de cevada",
    "traços de glúten",
    "traços de trigo",
    "vestígios de glúten",
    "vestígios de trigo",
    "pode conter glúten",
    "pode conter trigo",

    // Olandese
    "kan sporen van glutenbevattende granen bevatten",
    "kan sporen van gluten bevatten",
    "kan sporen van tarwe bevatten",
    "kan sporen van gerst bevatten",
    "sporen van gluten",
    "sporen van tarwe",
    "sporen van gerst",
    "kan gluten bevatten",
    "kan tarwe bevatten",

    // Polacco
    "może zawierać śladowe ilości zbóż zawierających gluten",
    "może zawierać śladowe ilości glutenu",
    "może zawierać śladowe ilości pszenicy",
    "śladowe ilości glutenu",
    "śladowe ilości pszenicy",
    "może zawierać gluten",
    "może zawierać pszenicę",

    // Turco
    "eser miktarda gluten içeren tahıllar içerebilir",
    "eser miktarda gluten içerebilir",
    "eser miktarda buğday içerebilir",
    "gluten içerebilir",
    "buğday içerebilir",
  ];

  static const List<String> safeTextKeywords = [
    // Italiano
    "senza glutine", "spiga sbarrata", "spiga barrata",
    "naturalmente privo di glutine", "adatto ai celiaci",
    // Inglese
    "gluten free", "gluten-free", "suitable for celiacs",
    // Spagnolo
    "sin gluten", "libre de gluten",
    // Francese
    "sans gluten",
    // Tedesco
    "glutenfrei",
    // Portoghese
    "sem glúten",
    // Olandese
    "glutenvrij",
    // Polacco
    "bezglutenowy", "bez glutenu",
    // Turco
    "glutensiz",
    // Russo
    "без глютена", "безглютеновый",
    // Ceco
    "bezlepkový", "bez lepku",
    // Romeno
    "fără gluten",
    // Ungherese
    "gluténmentes",
    // Greco
    "χωρίς γλουτένη",
    // Arabo
    "خالي من الغلوتين",
    // Giapponese
    "グルテンフリー",
  ];

  static const List<String> oatKeywords = [
    "avena",
    "oat",
    "oats",
    "oatmeal",
    "avoine",
    "hafer",
    "haver",
    "havre",
    "owies",
    "yulaf",
  ];

  /// Ingredienti mono-ingrediente ad alto rischio di contaminazione crociata industriale
  /// (farine, amidi, fiocchi, semole, legumi secchi, pseudocereali macinati).
  static const List<String> highRiskMonoIngredientKeywords = [
    // Italiano
    "farina", "farine", "amido", "amidi", "fecola", "semola", "semolino",
    "fiocchi", "crusca", "polenta", "tapioca", "manioca", "lenticchie",
    "ceci", "fagioli", "piselli", "soia", "miglio", "sorgo", "quinoa",
    "amaranto", "teff", "grano saraceno", "avena", "popcorn", "tofu", "tempeh",
    // Inglese
    "flour", "starch", "semolina", "flakes", "bran", "cornmeal", "lentils",
    "chickpeas", "beans", "peas", "soy", "millet", "sorghum", "amaranth",
    "buckwheat", "oat", "oats", "oatmeal",
    // Francese
    "amidon", "fécule", "semoule", "flocons", "son", "lentilles",
    "pois chiches", "haricots", "soja", "avoine", "sarrasin",
    "blé noir", "ble noir",
    // Spagnolo
    "harina", "almidón", "sémola", "copos", "salvado", "lentejas",
    "garbanzos", "alubias", "trigo sarraceno",
    // Tedesco
    "mehl", "stärke", "grieß", "flocken", "kleie", "linsen",
    "kichererbsen", "bohnen", "hafer", "buchweizen",
  ];

  static final RegExp _negatedSafeClaimRegex = RegExp(
    r'\b('
    r'non\s+adatto\s+(?:ai\s+celiaci|per\s+celiaci)\b'
    r'|(?:non\s+adatto\s+(?:a\s+(?:una\s+)?dieta\s+)|non\s+(?:è|e|sono)\s+|not\s+|is\s+not\s+|isn\x27t\s+|not\s+suitable\s+for\s+(?:a\s+)?|no\s+es\s+|no\s+apto\s+para\s+|n\x27est\s+pas\s+|ne\s+convient\s+pas\s+(?:à|aux)\s+|nicht\s+(?:für\s+)?|kein\s+)(?:un\s+prodotto\s+)?(?:senza\s+glutine|gluten[\s\-]free|sans\s+gluten|sin\s+gluten|libre\s+de\s+gluten|glutenfrei|glutenvrij|sem\s+glúten|adatto\s+ai\s+celiaci|suitable\s+for\s+celiacs)'
    r'|(?:senza\s+glutine|gluten[\s\-]free|sans\s+gluten|sin\s+gluten|glutenfrei)\s*[:\-]\s*(?:no|non|not|nein|false)\b'
    r')',
    caseSensitive: false,
  );

  /// Restituisce `true` se il testo contiene una negazione esplicita di un claim senza glutine.
  static bool hasNegatedGlutenClaim(String text) {
    if (text.trim().isEmpty) return false;
    final normalized = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    return _negatedSafeClaimRegex.hasMatch(normalized);
  }

  /// Restituisce `true` se il testo contiene un claim testuale "senza glutine" NON negato.
  static bool hasSafeGlutenTextClaim(String text) {
    if (text.trim().isEmpty) return false;
    final normalized = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final stripped = normalized.replaceAll(_negatedSafeClaimRegex, ' ');
    return safeTextKeywords.any((s) => stripped.contains(s));
  }

  static const List<String> doubtfulAdditives = [
    // Italiano
    "amido modificato",
    "lievito",
    "aromi",
    "fibra vegetale",
    // Inglese
    "modified starch",
    "yeast",
    "flavorings",
    "flavourings",
    "vegetable fiber",
    "vegetable fibre",
    // Francese
    "amidon modifié",
    "levure",
    "arômes",
    "fibre végétale",
    // Spagnolo
    "almidón modificado",
    "levadura",
    "aromas",
    "fibra vegetal",
    // Tedesco
    "modifizierte stärke",
    "hefe",
    "aromen",
    "pflanzenfaser",
  ];

  static const Set<String> agglutinativeRoots = {
    'weizen',
    'gerste',
    'roggen',
    'dinkel',
    'tarwe',
    'gerst',
    'rogge',
    'milch',
    'laktose',
    'malz',
    'hafer',
  };

  /// Costruisce la regex per [keyword] rispettando i confini di parola Unicode,
  /// fatta eccezione per le radici di lingue agglutinanti (tedesco/olandese).
  static RegExp keywordRegex(String keyword) {
    final isAgglutinative = agglutinativeRoots.contains(keyword.toLowerCase());
    return isAgglutinative
        ? RegExp(RegExp.escape(keyword), caseSensitive: false)
        : RegExp(
            r'(?<!\p{L})' + RegExp.escape(keyword) + r'(?!\p{L})',
            caseSensitive: false,
            unicode: true,
          );
  }

  /// Verifica se [text] contiene [keyword] rispettando i confini di parola Unicode,
  /// fatta eccezione per le radici di lingue agglutinanti (tedesco/olandese).
  static bool containsKeyword(String text, String keyword) =>
      keywordRegex(keyword).hasMatch(text);

  static const List<String> naturallySafeCategories = [
    'en:waters',
    'en:spring-waters',
    'en:mineral-waters',
    'en:milks',
    'en:fresh-milks',
    'en:fresh-fruits',
    'en:fruits',
    'en:fresh-vegetables',
    'en:vegetables',
    'en:extra-virgin-olive-oils',
    'en:olive-oils',
    'en:virgin-olive-oils',
    'en:sugars',
    'en:honeys',
    'en:salts',
    'en:coffees',
    'en:teas',
  ];

  /// Normalizza il testo grezzo (OCR / impaginazione): rimuove caratteri invisibili,
  /// uniforma apostrofi e trattini tipografici e ricongiunge sillabazioni a fine riga.
  static String normalizeOcrText(String input) {
    if (input.isEmpty) return input;
    return input
        .replaceAll(RegExp(r'[\u00AD\u200B\u200C\u200D\uFEFF]'), '')
        .replaceAll(RegExp(r'[’‘`]'), "'")
        .replaceAll(RegExp(r'[–—−]'), '-')
        .replaceAll(RegExp(r'-\s*[\r\n]+\s*'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static final RegExp _traceColonRegex = RegExp(
    r'\b(può contenere(?:\s+tracce\s+di)?|tracce\s+di|may contain(?:\s+traces\s+of)?|traces\s+of|peut contenir(?:\s+des\s+traces\s+d[e\x27])?|traces\s+d[e\x27]|puede contener(?:\s+trazas\s+de)?|trazas\s+de|kann(?:\s+spuren\s+von)?\s+enthalten|kann\s+enthalten|spuren\s+von|pode conter(?:\s+(?:vestígios|traços)\s+de)?|kan(?:\s+sporen\s+van)?\s+bevatten)\s*:\s*',
    caseSensitive: false,
  );

  /// Normalizza i due punti dopo i prefissi delle diciture di tracce
  /// (es. "Può contenere: glutine" -> "Può contenere glutine").
  static String normalizeTraceColons(String input) {
    if (input.isEmpty) return input;
    return input.replaceAllMapped(_traceColonRegex, (m) => '${m[1]} ');
  }

  static const List<String> safePhrases = [
    "amido di frumento deglutinato",
    "amido di grano deglutinato",
    "deglutinated wheat starch",
    "wheat starch deglutinated",
    "amidon de blé déglutiné",
    "almidón de trigo deglutenizado",
    "glutenfreie weizenstärke",
    "grano saraceno",
    "grano-saraceno",
    "blé noir",
    "ble noir",
    "blé-noir",
    "senza glutine",
    "senza-glutine",
    "privo di glutine",
    "gluten free",
    "gluten-free",
    "sans gluten",
    "sin gluten",
    "libre de gluten",
    "spiga barrata",
    "spiga sbarrata",
    "adatto ai celiaci",
    "zero glutine",
    "deglutinato",
    "deglutinata",
    "deglutinati",
    "deglutinate",
    "degliutinato",
    "deglutenized",
    "deglutenised",
  ];

  static const List<String> lactoseSafePhrases = [
    "senza lattosio",
    "privo di lattosio",
    "lactose free",
    "lactose-free",
    "sans lactose",
    "sin lactosa",
    "delattosato",
    "senza latte",
  ];

  /// Restituisce gli intervalli `[start, end)` in [rawText] appartenenti a frasi
  /// sicure multilingua (es. "senza glutine", "gluten-free", "amido di frumento deglutinato",
  /// "grano saraceno", "blé noir") per evitare falsi highlight in UI.
  static List<({int start, int end})> findProtectedHighlightRanges(
    String rawText, {
    bool isLactose = false,
  }) {
    final ranges = <({int start, int end})>[];
    final phrases = isLactose
        ? lactoseSafePhrases
        : <String>{...safePhrases, ...safeTextKeywords}.toList();

    for (final phrase in phrases) {
      if (phrase.isEmpty) continue;
      final regex = RegExp(RegExp.escape(phrase), caseSensitive: false);
      for (final match in regex.allMatches(rawText)) {
        ranges.add((start: match.start, end: match.end));
      }
    }
    return ranges;
  }

  // Nasconde le frasi sicure per non far scattare l'allarme sulla parola "glutine"
  static String sanitizeForGluten(String input) {
    String text = normalizeTraceColons(normalizeOcrText(input).toLowerCase());
    for (var phrase in safePhrases) {
      text = text.replaceAll(phrase, " ");
    }
    for (var phrase in traceKeywords) {
      text = text.replaceAll(phrase, " ");
    }
    // Ricongiunge sillabazioni OCR residue tra lettere (es. "fru-mento" -> "frumento")
    text = text.replaceAllMapped(
      RegExp(r'([a-zA-ZÀ-ÿ])-([a-zA-ZÀ-ÿ])'),
      (m) => '${m[1]}${m[2]}',
    );
    return text;
  }

  // Nasconde le frasi sicure per non far scattare l'allarme sulla parola "lattosio"
  static String sanitizeForLactose(String input) {
    String text = input.toLowerCase();
    for (var phrase in lactoseSafePhrases) {
      text = text.replaceAll(phrase, " ");
    }
    return text;
  }
}
