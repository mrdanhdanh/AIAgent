using Bunit;
using Microsoft.Extensions.DependencyInjection;
using MudBlazor.Services;

namespace JapaneseLearner.Tests.TestHelpers;

public class BunitTestBase : IAsyncDisposable
{
    protected readonly BunitContext Context;

    public BunitTestBase()
    {
        Context = new BunitContext();
        Context.Services.AddMudServices();
        Context.JSInterop.SetupVoid("mudElementRef.addOnBlurEvent", _ => true);
        Context.JSInterop.SetupVoid("mudElementRef.addOnFocusEvent", _ => true);
        Context.JSInterop.SetupVoid("mudKeyInterceptor.connect", _ => true);
        Context.JSInterop.SetupVoid("mudKeyInterceptor.disconnect", _ => true);
        Context.JSInterop.SetupVoid("mudPopover.connect", _ => true);
        Context.JSInterop.SetupVoid("mudPopover.disconnect", _ => true);
        Context.JSInterop.SetupVoid("mudElementRef.addOnPointerDownEvent", _ => true);
        Context.JSInterop.SetupVoid("mudElementRef.addOnPointerUpEvent", _ => true);
        Context.JSInterop.SetupVoid("mudElementRef.addOnPointerMoveEvent", _ => true);
        Context.JSInterop.SetupVoid("mudPopover.initialize", _ => true);
        Context.JSInterop.SetupVoid("mudPopover.destroy", _ => true);
        Context.JSInterop.SetupVoid("mudInput.initialize", _ => true);
        Context.JSInterop.SetupVoid("mudInput.destroy", _ => true);
        Context.JSInterop.SetupVoid("mudRipple.connect", _ => true);
        Context.JSInterop.SetupVoid("mudRipple.disconnect", _ => true);
        Context.JSInterop.SetupVoid("mudSelect.addScrollListener", _ => true);
        Context.JSInterop.SetupVoid("mudSelect.removeScrollListener", _ => true);
        Context.JSInterop.SetupVoid("mudInputElement.select", _ => true);
        Context.JSInterop.SetupVoid("mudInputElement.selectRange", _ => true);
    }

    public async ValueTask DisposeAsync()
    {
        if (Context != null)
            await Context.DisposeAsync();
    }
}
