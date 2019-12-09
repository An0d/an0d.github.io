---
layout: post
title:  "Visual Studio et  les caractères spéciaux  dans le mot de passe de l'Android Keystore"
date:   2019-12-08
author: An0d
permalink: /vs-android-keystore-password-special-characters/
categories: dev
tags: xamarin android visual-studio
---
Quand on crée un Keystore Android avec Visual Studio, il faut entrer un mot de passe histoire de protéger le Keystore. On tape alors ce qu'on veut.
En tant que dev qui s'intéresse un petit peu à la sécurité, je tape évidemment un mot de passe bien long, auto-généré avec [Bitwarden](https://bitwarden.com/), mon gestionnaire de mot de passe préféré, qui contient alors des lettres, des chiffres, des minuscules, des majuscules et des caractères spéciaux...
Je signais jusque-là mes APKs avec Visual Studio sans problème.

Puis, je décide de mettre en place un build automatique dans Azure DevOps (On Premise chez le client) avec signature automatique des APKs.

J'ai appris à mes dépens qu'il vallait mieux éviter les caractères spéciaux dans le mot de passe du Keystore.

En effet, quand j'ai voulu configurer la signature automatique des APKs, dans Azure DevOps, j'ai rencontré l'erreur suivante :

    java.io.IOException: Keystore was tampered with, or password was incorrect
            at sun.security.provider.JavaKeyStore.engineLoad(Unknown Source)
            at sun.security.provider.JavaKeyStore$JKS.engineLoad(Unknown Source)
            at sun.security.provider.KeyStoreDelegator.engineLoad(Unknown Source)
            at sun.security.provider.JavaKeyStore$DualFormatJKS.engineLoad(Unknown Source)
            at java.security.KeyStore.load(Unknown Source)
            at com.android.apksigner.ApkSignerTool$SignerParams.loadKeyStoreFromFile(ApkSignerTool.java:829)
            at com.android.apksigner.ApkSignerTool$SignerParams.loadPrivateKeyAndCertsFromKeyStore(ApkSignerTool.java:719)
            at com.android.apksigner.ApkSignerTool$SignerParams.loadPrivateKeyAndCerts(ApkSignerTool.java:659)
            at com.android.apksigner.ApkSignerTool$SignerParams.access$500(ApkSignerTool.java:611)
            at com.android.apksigner.ApkSignerTool.sign(ApkSignerTool.java:266)
            at com.android.apksigner.ApkSignerTool.main(ApkSignerTool.java:89)
    Caused by: java.security.UnrecoverableKeyException: Password verification failed
            ... 11 more

Message d'erreur on ne peut plus clair...

Après quelques recherches sur l'internet mondial, j'ai compris que l'outil utilisé (apksigner) ne supportait pas les caractères spéciaux dans le mot de passe...

Petit coup de stress...
Comment modifier le mot de passe d'un Keystore déjà existant, histoire de dégager les caractères spéciaux ?
J'ai trouvé un outil qui m'a sauvé la vie : [KeyStore Explorer](https://keystore-explorer.org/)

Conclusion, évitez de mettre des caracètres spéciaux dans le mot de passe de votre Keystore...