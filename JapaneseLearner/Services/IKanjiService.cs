using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public interface IKanjiService
{
    Task<List<JapaneseKanji>> GetAllAsync(IProgress<int>? progress = null);
    Task<JapaneseKanji?> GetByIdAsync(int id);
    Task<List<JapaneseKanji>> GetByLevelAsync(string level);
    Task AddAsync(JapaneseKanji k);
    Task UpdateAsync(JapaneseKanji k);
    Task DeleteAsync(int id);
}
