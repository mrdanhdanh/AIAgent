using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public interface ICharService
{
    Task<List<JapaneseChar>> GetAllAsync();
    Task<List<JapaneseChar>> GetByTypeAsync(string type);
    Task AddAsync(JapaneseChar c);
    Task UpdateAsync(JapaneseChar c);
    Task DeleteAsync(int id);
}
