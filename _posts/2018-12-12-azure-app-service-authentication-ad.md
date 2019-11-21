---
layout: post
title:  "Sécuriser une application Azure App Service avec Azure Active Directory"
date:   2018-12-12
author: An0d
permalink: /azure-app-service-authentication-ad/
categories: azure
tags: azure azure-active-directory azure-app-services sécurité authentication
---
La fonctionnalité App Service de Microsoft Azure offre la possibilité de sécuriser rapidement et facilement une application web (Web App, Web API, Function App) simplement avec un peu de configuration dans Azure, et ce, peu importe la technologie qui se cache dans votre application App Service.

En quelques clics, sans même écrire une seule ligne de code dans votre application, vous pouvez restreindre l’accès à celle-ci aux utilisateurs enregistrés dans votre Azure Active Directory. Si vous le souhaitez, vous pouvez également permettre à vos utilisateurs de s’authentifier avec leur compte Facebook, Google, Twitter ou Microsoft.

Cet article décrit comment restreindre l’accès à une application Azure App Service avec Azure Active Directory.
Je partagerai également avec vous une information que j’ai eu beaucoup de mal à trouver sur le net. Qui est d’utiliser un autre Azure Active Directory que celui sur lequel est déployée votre application.

Personnellement, je trouve que cette méthode est un excellent moyen de sécuriser une application sans se prendre la tête. On se repose sur l’implémentation et l’expertise de Microsoft. En effet, la sécurisation des applications exige une connaissance approfondie de la sécurité sous divers aspects. Avec cette fonctionnalité proposée par Microsoft Azure, pas besoin de réinventer la roue et de développer soi-même l’authentification ni la gestion des utilisateurs et des rôles. Pas besoin d’écrire, maintenir ni de corriger de code. On peut se concentrer sur l’essentiel, notre application.

La configuration se passe essentiellement au niveau de l’App Service dans Azure. La gestion des utilisateurs et des rôles se passe dans Azure Active Directory.

Attention, ça va aller très vite :

> * Rendez-vous dans le portail Azure
>
> * Dans la colonne de gauche, cliquez sur le menu `App Services`
>
> * Sélectionnez l’App Service que vous souhaitez sécuriser
>
> * Cliquez sur le menu `Authentication / Authorization` (sous la section `Settings`)
>
> * Sous `App Service Authentication`, cliquez sur `On`
>
> * Dans la liste `Action to take when request is not authenticated`, sélectionnez `Log in with Azure Active Directory`
>
> * Sous `Authentication Providers`, cliquez sur `Azure Active Directory`
>
> * Dans le nouvel écran qui s’ouvre, sous `Management mode`, sélectionnez `Express` et validez en cliquant sur `OK`
>
> * N’oubliez surtout pas de sauvegarder la nouvelle configuration en cliquant sur le bouton `Save`

Et voilà, à partir de maintenant, lorsque vous tenterez d’accéder à votre application, vous serez automatiquement redirigé vers une page de login Microsoft. Seuls les utilisateurs enregistrés dans votre Azure Active Directory pourront s’y connecter.

Comment utiliser un autre Azure Active Directory que celui sur lequel est déployée votre application?

J’ai eu un peu de mal à trouver comment faire mais cela s’avère très simple finalement.

Une fois que vous avez configuré votre App Service comme expliqué ci-dessus :

> * Retournez dans le menu `Authentication / Authorization` de votre App Service
>
> * Sous `Authentication Providers`, cliquez sur `Azure Active Directory`
>
> * Sous `Management mode`, passez de `Express` à `Advanced`
>
> * Le champ `Issuer Url` représente en fait l’url de l’Azure Active Directory à utiliser
>
> * Cette url se présente comme ceci `https://sts.windows.net/{directoryId}/`<br />
> Où `{directoryId}` représente l’identifiant de l’Azure Active Directory à utiliser
>
> Exemple
> `https://sts.windows.net/f77bc3b5-2453-423f-a519-7bf232f405fb/`<br /><br />
> * Dans le champ `Issuer Url`, remplacez simplement la partie `{directoryId}` par l’identifiant de l’Azure Active Directory que vous souhaitez utiliser<br />
>   * Pour retrouver l’identifiant d’un Azure Active Directory
>       * Rendez-vous dans le portail Azure
>       * Cliquez sur `Azure Active Directory` puis sur `Properties`
>       * L’identifiant que vous cherchez se trouve dans le champ Directory ID

En espérant vous avoir aidé
