export function observe(element, dotNetRef) {
    const observer = new IntersectionObserver((entries) => {
        if (entries[0].isIntersecting) {
            dotNetRef.invokeMethodAsync('OnIntersect');
        }
    }, { threshold: 0.1 });

    observer.observe(element);
    element._intersectionObserver = observer;
}

export function unobserve(element) {
    if (element._intersectionObserver) {
        element._intersectionObserver.disconnect();
        delete element._intersectionObserver;
    }
}
