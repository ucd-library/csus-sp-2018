<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org0715761">1. Example 1 - Pets</a>
<ul>
<li><a href="#orgd2f68dd">1.1. Administrative Privledges</a></li>
<li><a href="#orgbad83ce">1.2. Make a new Collection</a></li>
<li><a href="#orgd261e81">1.3. Collection Access Control</a></li>
</ul>
</li>
</ul>
</div>
</div>
:header-args:    :exports both :eval no-export :cache yes


<a id="org0715761"></a>

# Example 1 - Pets

This example collection is something like the most basic type of collection that
can be added into the system.  This example contains a simple set of digital
images, with a small amount of data about the pets.  Our goal is to take these
data and add them into our DAMs.


<a id="orgd2f68dd"></a>

## Administrative Privledges

If you have gone through the installation steps, this is good place to come as
your next step.  The steps below assume that you are currently logged in to your
fin server, as an admin.  How to do this is explained in the installation
instructions.  You can verify this with the following command, which access the
root location, and verifies you can write to this location.

    fin http get -P b / | grep fedora:writable

    true


<a id="orgbad83ce"></a>

## Make a new Collection

Let&rsquo;s start with the collection description.  That&rsquo;s stored in the \`index.ttl\`
file.  This file describes the collection. \`index.ttl\` is a pretty easy file to
understand, you&rsquo;ll see a title, and description and some keywords.  If you&rsquo;re
savy with your linked data, you will see that by default we like to use
schema.org for our descriptions.  This is not a requirement for the server, but
lots of the DAMS setup expects to use this schema when indexing collections and
data.

    @prefix : <http://schema.org/> .
    @prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix ldp:  <http://www.w3.org/ns/ldp#> .

    <>
      a ldp:BasicContainer, :Collection;
      :title "Collaborator Pets";
      :keywords "Pets", "Cats", "Dogs";
      :license <http://rightsstatements.org/vocab/InC-NC/1.0/>;
      :creator "Quinn Hart";
      :datePublished "2018" ;
      :description "This collection includes pictures of pets that are owned by our collaborators.  This is meant to be something of the most basic collection that can be added as a DAMs.".

fin has some special commands to create and administrate collections.  Let&rsquo;s
go ahead and create our new collection.

    fin collection create example_1-pets index.ttl

    New collection created at: /collection/example_1-pets

This command creates a new container in our system, for the new collection, but
it does more than that. It sets up some default access control conditions, and
organizes standard locations for things like groups for this collection. Also,
with the addition of the metadata in our index.ttl file, it also describes the
contents of this collection, which is then used in the default Interface for the
repository. After this step, you should be able to navigate to
<http://localhost:3000/fcrepo/rest/collection>, and see your newly created
example<sub>1</sub>-pets collection. You may need to login to your account via
<http://localhost:3000/auth/basic/login.html> to give your browser access.


<a id="orgd261e81"></a>

## Collection Access Control

By default new collections are not publicly available.  Let&rsquo;s make this
available for anyone.

    fin collection acl user add example_1-pets foaf:Agent r
