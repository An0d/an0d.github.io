---
layout: post
title:  "Xamarin.Android : Fermer automatiquement le clavier lorsqu'on implémente l'évènement EditorAction"
date:   2019-11-18
author: An0d
categories: dev
tags: xamarin android .net c#
---
Android permet de remplacer la touche `Enter` du clavier par une action spécifique grâce à l'attribut `android:imeOptions` (moyennant l'attribut `android:singleLine="true"`) qu'on peut placer sur un `EditText`, par exemple.

|imeOptions|Capture d'écran|
|------|---------------|
|`android:imeOptions="actionDone"`|![actionDone](/assets/android/imeOptions/action-done.png)|
|`android:imeOptions="actionNext"`|![actionNext](/assets/android/imeOptions/action-next.png)|
|`android:imeOptions="actionSearch"`|![actionSearch](/assets/android/imeOptions/action-search.png)|

Lorsque cette option est spécifiée, le clavier se ferme automatiquement au moment où l'utilisateur clique sur le *bouton d'action*. Jusque là tout va bien.

Mais il faut bien implémenter le comportement attendu, comme lancer la recherche par exemple. On doit alors s'abonner à l'évènement `EditorAction`.

```cs
private EditText searchStringEditText;

protected override void OnCreate(Bundle bundle)
{
    base.OnCreate(bundle);

    this.searchStringEditText = this.FindViewById<EditText>(Resource.Id.et_searchString);
    this.searchStringEditText.EditorAction += this.SearchStringEditTextOnEditorAction;
}

private void SearchStringEditTextOnEditorAction(object sender, TextView.EditorActionEventArgs e)
{
    if (e.ActionId == ImeAction.Search)
    {
        // Implémentation de la recherche
    }
}
```

Et là, *surpriiiise*, le clavier ne se ferme plus lorsque l'utilisateur clique sur le fameux *bouton d'action*...

***Pourquoi ?***

Dès lors qu'on s'abonne à l'évènement `EditorAction`, la valeur de la propriété `Handled` de `TextView.EditorActionEventArgs` passe automatiquement à `true`.
Ce qui sous-entend que l'on va prendre en charge l'intégralité de l'implémentation du comportement lorsque l'utilisateur clique sur le *bouton d'action*. Et donc que le comportement par défaut (la fermeture du clavier) est simplement ignoré...

L'astuce est de remettre la valeur de `e.Handled` à `false` histoire de conserver le comportement par défaut (la fermeture du clavier) malgré notre implémentation.

```cs
private void SearchStringEditTextOnEditorAction(object sender, TextView.EditorActionEventArgs e)
{
    e.Handled = false;

    if (e.ActionId == ImeAction.Search)
    {
        // Implémentation de la recherche
    }
}
```

*Source : [StackOverflow](https://stackoverflow.com/a/3449616/6936427)*