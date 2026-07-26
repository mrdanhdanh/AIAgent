namespace JapaneseLearner.Models;

public class JapaneseKanji
{
    public int Id { get; set; }
    public string Kanji { get; set; } = string.Empty;
    public string OnYomi { get; set; } = string.Empty;
    public string KunYomi { get; set; } = string.Empty;
    public string Meaning { get; set; } = string.Empty;
    public int StrokeCount { get; set; }
    public string JLPTLevel { get; set; } = "N5";
    public List<string> Examples { get; set; } = new();
    public List<string> Strokes { get; set; } = new();
}
