namespace JapaneseLearner.Models;

public class JapaneseGrammar
{
    public int Id { get; set; }
    public string Pattern { get; set; } = string.Empty;
    public string Meaning { get; set; } = string.Empty;
    public string Explanation { get; set; } = string.Empty;
    public string JLPTLevel { get; set; } = "N5";
    public List<string> Examples { get; set; } = new();
}