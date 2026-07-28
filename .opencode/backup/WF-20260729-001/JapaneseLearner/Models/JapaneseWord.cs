namespace JapaneseLearner.Models;

public class JapaneseWord
{
    public int Id { get; set; }
    public string Characters { get; set; } = string.Empty;
    public string Romaji { get; set; } = string.Empty;
    public string Meaning { get; set; } = string.Empty;
    public string Type { get; set; } = "Seion";
}
