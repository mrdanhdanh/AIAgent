using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public interface IWordService
{
    Task<List<JapaneseWord>> GetAllAsync();
    Task<List<JapaneseWord>> GetByTypeAsync(string type);
    Task AddAsync(JapaneseWord w);
    Task UpdateAsync(JapaneseWord w);
    Task DeleteAsync(int id);
}
