using Bunit;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FluentUI.AspNetCore.Components;

namespace JapaneseLearner.Tests.TestHelpers;

public class BunitTestBase : IAsyncDisposable
{
    protected readonly BunitContext Context;

    public BunitTestBase()
    {
        Context = new BunitContext();
        Context.Services.AddFluentUIComponents();

        var js = Context.JSInterop;

        var ver = "?v=4.14.3.26174";
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/List/ListComponentBase.razor.js" + ver);
        var labelModule = js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Label/FluentInputLabel.razor.js" + ver);
        labelModule.SetupVoid("setInputAriaLabel", _ => true);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Dialog/FluentDialog.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Select/FluentSelect.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/TextField/FluentTextField.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/ProgressRing/FluentProgressRing.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Button/FluentButton.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/NavMenu/FluentNavMenu.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/DesignTheme/FluentDesignTheme.razor.js" + ver);
    }

    public async ValueTask DisposeAsync()
    {
        if (Context != null)
            await Context.DisposeAsync();
    }
}