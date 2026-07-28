using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public interface IGrammarService
{
    Task<List<JapaneseGrammar>> GetAllAsync(IProgress<int>? progress = null);
    Task<JapaneseGrammar?> GetByIdAsync(int id);
    Task<List<JapaneseGrammar>> GetByLevelAsync(string level);
    Task AddAsync(JapaneseGrammar g);
    Task UpdateAsync(JapaneseGrammar g);
    Task DeleteAsync(int id);
}