import jenkins.model.*
import hudson.security.*
import hudson.tasks.Mailer

def instance = Jenkins.getInstance()

def realm = new HudsonPrivateSecurityRealm(false)

// Create admin user (idempotent)
def user = realm.getUser("admin")
if (user == null) {
    user = realm.createAccount("admin", "Admin@123")
}

// Full name
user.setFullName("Jenkins Admin")

// Email
user.addProperty(new Mailer.UserProperty("admin@example.com"))

// Apply security
instance.setSecurityRealm(realm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()
