namespace JapaneseLearner.Models;

public class JapaneseChar
{
    public int Id { get; set; }
    public string Character { get; set; } = string.Empty;
    public string Romaji { get; set; } = string.Empty;
    public string Type { get; set; } = "Hiragana";
}
