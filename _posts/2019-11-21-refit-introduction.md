---
layout: post
title:  "Introduction à Refit : la bibliothèque qui vous facilite le REST"
date:   2019-11-21
author: An0d
permalink: /refit-introduction/
categories: dev
tags: .net c# nuget refit
---
## Présentation
[*Refit*](https://reactiveui.github.io/refit/) est une bibliothèque REST pour .NET, .NET Core et Xamarin qui s'inspire fortement de la bibliothèque [Retrofit](http://square.github.io/retrofit) de Square. Elle convertit une API REST en interface dynamique. 

En d'autres termes, *Refit* permet de générer dynamiquement un client .NET fortement typé autour d'une API REST.

Pour cela, il suffit *juste* de déclarer une [`interface`](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/interface) dans laquelle on vient spécifier les informations liées à l'API REST (routes, paramètres, corps, en-têtes, etc...) :

```cs
public interface IMyApi
{
    [Get("/users/{user}")]
    Task<User> GetUser(string user);
}
```

Grâce à la classe `RestService`, *Refit* s'occupe alors de générer dynamiquement une implémentation de l'interface qui utilise `HttpClient` pour effectuer les appels HTTP :

```cs
var myApi = RestService.For<IMyApi>("https://api.server.com");

var octocat = await myApi.GetUser("An0d");
>>> "/users/An0d"
```

---
## Installation

Via **Package Manager Console**
```powershell
PM> Install-Package refit
```

Via **NuGet Package Manager**
![refit](/assets/nuget/refit.png)

---

## Utilisation

### URL dynamique

Passer un paramètre dans l'URL
```cs
[Get("/group/{groupId}/users")]
Task<List<User>> GroupList(int groupId);

GroupList(4);
>>> "/group/4/users"
```
Le paramètre `{groupId}` dans l'URL sera automatiquement remplacé par la valeur du paramètre homonyme `groupId` passé à la méthode.

Si le nom du paramètre passé à la méthode ne correspond pas au nom du paramètre dans l'URL, on peut alors utiliser l'attribut `[AliasAs]`
```cs
[Get("/group/{id}/users")]
Task<List<User>> GroupList([AliasAs("id")]int groupId);

GroupList(4);
>>> "/group/4/users"
```

### Paramètres de requête

***Tous les paramètres passés à la méthode qui ne sont pas repris dans l'URL sont automatiquement utilisés en tant que paramètres de requête***
```cs
[Get("/group/{id}/users")]
Task<List<User>> GroupList([AliasAs("id")]int groupId, string sort);

GroupList(4, "desc");
>>> "/group/4/users?sort=desc"
```

Si on veut passer une liste en tant que paramètres de requête
```cs
[Get("/users/list")]
Task Search([Query(CollectionFormat.Multi)]int[] ages);

Search(new [] {10, 20, 30})
>>> "/users/list?ages=10&ages=20&ages=30"

[Get("/users/list")]
Task Search([AliasAs("age")][Query(CollectionFormat.Multi)]int[] age);

Search(new [] {10, 20, 30})
>>> "/users/list?age=10&age=20&age=30"
```

### Corps de la requête

L'un des paramètres de la méthode peut être utilisé comme corps de la requête si on le marque avec l'attribut `[Body]`
```cs
[Post("/users/new")]
Task CreateUser([Body] User user);
```

Si le corps de la requête est simplement une chaîne de caractère on peut préciser `BodySerializationMethod.Serialized` pour l'attribut `[Body]`
```cs
[Post("/posts/{id}/comments")]
Task AddComment([AliasAs("id")]int postId, [Body(BodySerializationMethod.Serialized)]string comment);
```

### En-têtes
Pour définir un header statique au niveau d'une requête, on doit marquer la méthode avec l'attribut `[Headers]`
```cs
[Headers("User-Agent: Crush-IT App")]
[Get("/users/{user}")]
Task<User> GetUser(string user);
```

Pour définir un header statique pour toutes les requêtes de l'API, on doit marquer l'interface avec l'attribut `[Headers]`
```cs
[Headers("User-Agent: Crush-IT App")]
public interface IMyApi
{
    [Get("/users/{user}")]
    Task<User> GetUser(string user);
    
    [Post("/users/new")]
    Task CreateUser([Body] User user);
}
```

Si le contenu du header doit être défini à l'exécution, on peut ajouter un header avec une valeur dynamique en marquant un paramètre de la méthode avec l'attribut `[Header]`
```cs
[Get("/users/{user}")]
Task<User> GetUser(string user, [Header("Authorization")]string authorization);

// Ajoute le header "Authorization: token OAUTH-TOKEN" à la requête
var user = await GetUser("octocat", "token OAUTH-TOKEN"); 
```
---

## Conclusion

J'adore cette bibliothèque, j'aurais aimé la découvrir plus tôt. Elle me facilite beaucoup la vie au quotidien et je la trouve très simple à prendre en main.

Evidemment, *Refit* a bien plus à offrir que les quelques exemples que j'ai repris ci-dessus. Je vous invite donc à consulter leur [Repo GitHub](https://github.com/reactiveui/refit) pour découvrir *Refit* plus en profondeur.

Dans un prochain article, j'expliquerai comment configurer *Refit* pour appeler une Web API hébergée sur Azure et sécurisée par *App Service Authentication* dont j'ai parlé dans mon [premier article]({% post_url 2018-12-12-azure-app-service-authentication-ad %})

---

## Info

### Site officiel
[https://reactiveui.github.io/refit/](https://reactiveui.github.io/refit/)

### Repository GitHub
*Je trouve que la doc y est plus à jour que sur le site officiel*

[https://github.com/reactiveui/refit](https://github.com/reactiveui/refit)

### Package NuGet
[https://www.nuget.org/packages/Refit/](https://www.nuget.org/packages/Refit/)