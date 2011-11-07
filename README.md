CvClient API - deploy apps to CvClient from the command line
========================================================

This library wraps the REST API for managing and deploying Rails apps to the
CvClient platform.  It can be called as a Ruby library, or invoked from the
command line.  Code push and pull is done through Git.

For more about CvClient see <http://cv_client.com>.

For full documentation see <http://cv_client.com/docs>.


Sample Workflow
---------------

Create a new Rails app and deploy it:

    rails myapp && cd myapp   # Create an app
    git init                  # Init git repository
    git add .                 # Add everything
    git commit -m Initial     # Commit everything
    cv_client create             # Create your app on CvClient
    git push cv_client master    # Deploy your app on CvClient


Setup
-----

    gem install cv_client

If you wish to push or pull code, you must also have a working install of Git
("apt-get install git-core" on Ubuntu or "port install git-core" on OS X), and
an ssh public key ("ssh-keygen -t rsa").

The first time you run a command, such as "cv_client list," you will be prompted
for your CvClient username and password. Your API key will be fetched and stored
locally to authenticate future requests.

Your public key (~/.ssh/id_[rd]sa.pub) will be uploaded to CvClient after you
enter your credentials. Use cv_client keys:add if you wish to upload additional
keys or specify a key in a non-standard location.

Meta
----

Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).

Created by CV Team

Maintained by CV Team
