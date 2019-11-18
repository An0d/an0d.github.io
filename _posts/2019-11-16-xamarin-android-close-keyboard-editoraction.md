---
layout: post
title:  "Xamarin.Android : Fermer automatiquement le clavier lorsqu'on implémente l'évènement EditorAction"
date:   2019-11-16
author: An0d
categories: dev
tags: xamarin android .net c#
---
Android permet de remplacer la touche `Enter` du clavier par une action spécifique grâce à l'attribut `android:imeOptions` qu'on peut placer sur un `EditText` (entre autre).

Quelques exemples

|Valeur|Capture d'écran|
|------|---------------|
|`android:imeOptions="actionDone"`|![actionDone](/assets/android/imeOptions/action-done.png)|
|`android:imeOptions="actionNext"`|![actionNext](/assets/android/imeOptions/action-next.png)|
|`android:imeOptions="actionSearch"`|![actionSearch](/assets/android/imeOptions/action-search.png)|

Lorsque cette option est précisée, sans rien faire de plus, le clavier se fermera automatiquement lorsque l'utilisateur cliquera sur le bouton d'action. Jusque là tout va bien.
Sauf que si on veut effectuer une recherche ... il va bien falloir l'implémenter cette recherche lorsqu'on clique sur le bouton d'action...
Du coup, on doit implémenter l'évènement `EditorAction` au niveau de l'Activity, côté C#

```cs
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
        // Code pour effectuer la recherche
    }
}
```

Et là, surpriiiise, le clavier ne se ferme plus quand on clique sur ce fucking bouton d'action. WTF ?
On cherche sur internet, StackOverflow etc... Là, on nous explique comment fermer le clavier de manière programmatique, bla bla bla
Perso je trouvais ça vachement relou alors que le comportement par défaut, avant d'implémenter l'évènement `EditorAction` fermait 