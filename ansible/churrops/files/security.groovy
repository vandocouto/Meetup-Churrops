#!groovy
import hudson.*
import hudson.security.*
import jenkins.model.*
import jenkins.security.s2m.AdminWhitelistRule
import jenkins.model.Jenkins

def instance = Jenkins.getInstance()

def user = new File("/run/secrets/jenkins-user").text.trim()
def pass = new File("/run/secrets/jenkins-pass").text.trim()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(user, pass)
instance.setSecurityRealm(hudsonRealm)

def strategy = new ProjectMatrixAuthorizationStrategy()
strategy.add(instance.ADMINISTER, user)
strategy.add(instance.READ, "authenticated")
instance.setAuthorizationStrategy(strategy)

instance.save()
Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)

