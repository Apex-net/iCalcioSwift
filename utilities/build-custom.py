#!/usr/bin/env python -u
# -*- coding: UTF-8 -*-

"""List or build custom targets."""

import os
import sys
import glob
import subprocess
import plistlib
import datetime
import hashlib

try:
    import argparse
except ImportError:
    raise ImportError("requires argparse module available in version 2.7 of python")
import shutil

__author__ = "Ali Servet Donmez"
__email__ = "asd@pittle.org"
__version__ = "0.3"

TARGETS_DIR_PATH = os.path.join(os.pardir, 'targets')
"""Targets directory path."""


class VCSError(Exception):
    pass

def parse_args():
    """TODOC."""
    parser = argparse.ArgumentParser(description='list/build custom targets or build ipa or distribute with testflgiht',
                                     epilog='')
    parser.add_argument('-t', '--target', nargs=1, metavar='<T>', help='name of the target to build')
    parser.add_argument('-l', '--list', action="store_true", dest="list", default=False, help='available target names list')
    parser.add_argument('-b', '--buildipa', action="store_true", dest="build", default=False, help='clean & build ipa')
    parser.add_argument('-d', '--distribute', action="store_true", dest="distribute", default=False, help='distribute to iTunes Connect')
    parser.add_argument('-a', '--all', action="store_true", dest="all", default=False, help='compile all targets')
    parser.add_argument('-p', '--pods', action="store_true", dest="pods", default=False, help='align all pods')

    return parser.parse_args()

def check_xcode_setup():
    if not glob.glob('*.xcodeproj'):
        return False
    return True

def check_subversion():
    svn_dir_name = '.svn'
    if not os.path.isdir(svn_dir_name):
        sys.stderr.write('svn: warning: \'%s\' is not a working copy\n' % os.getcwd())
        raise VCSError()
    relative_path = os.curdir
    while os.path.isdir(os.path.join(relative_path, os.pardir, svn_dir_name)):
        relative_path = os.path.join(relative_path, os.pardir)
    if subprocess.check_output(('svn status %s' % relative_path).split()):
        sys.stderr.write('Your current working directory is not clean.\n')
        return False
    return True

def check_git():
    try:
        if subprocess.check_call('git status'.split(), stdout=open(os.devnull,"w")) == 0:
            try:
                return subprocess.check_call('git diff --quiet'.split()) == 0
            except subprocess.CalledProcessError:
                sys.stderr.write('Your current git working directory is not clean.\n')
                return False
    except subprocess.CalledProcessError as e:
        if e.returncode == 128:
            sys.stderr.write('fatal: Not a git repository (or any of the parent directories): .git\n')
            raise VCSError()

def clean_git():
    # Check if current directory is under version control and that the working directory is clean
    try:
        if not check_git():
            try:
                if subprocess.check_call('git reset HEAD --hard'.split()) == 0:
                    return subprocess.check_call('git clean -fd'.split()) == 0
                return False
            except subprocess.CalledProcessError:
                sys.stderr.write('Error discarding all changes.\n')
                return False
    except VCSError:
        sys.stderr.write("%s: no valid version control system is found.\n" % filename)
        return False

def refreshPods():
    try:
        subprocess.check_call('pod install'.split(), stdout=open(os.devnull,"w"))
    except subprocess.CalledProcessError as e:
        sys.stderr.write("Error pod install: %s.\n"  % (e.returncode))
        return os.EX_CONFIG

    return os.EX_OK

def alignPods():
    try:
        sys.stdout.write("Aligning dependencies (Pods)..\n")
        subprocess.check_call('rm -rf Pods'.split(), stdout=open(os.devnull,"w"),stderr=sys.stdout)
        subprocess.check_call('mv Podfile.lock Podfile.lock.backup'.split(), stdout=open(os.devnull,"w"),stderr=sys.stdout)
        subprocess.check_call('pod install'.split(), stdout=open(os.devnull,"w"),stderr=sys.stdout)
        subprocess.check_call('mv Podfile.lock.backup Podfile.lock'.split(), stdout=open(os.devnull,"w"),stderr=sys.stdout)
        subprocess.check_call('pod install'.split(), stdout=open(os.devnull,"w"),stderr=sys.stdout)
        sys.stdout.write("Completed dependencies (Pods) alignment.\n")
    except subprocess.CalledProcessError as e:
        sys.stderr.write("Error aligning dependencies: %s.\n"  % (e.returncode))
        return os.EX_CONFIG

    return os.EX_OK

def check_target(target_path, config_pathname=None):
    if not os.path.isdir(target_path):
        sys.stderr.write('%s is not a directory.\n' % os.path.abspath(target_path))
        return False
    if not os.path.isdir(os.path.join(target_path, 'images')):
        sys.stderr.write('Missing \'images\' path in %s directory.\n' % os.path.abspath(target_path))
        return False
    configs = [os.path.basename(x) for x in glob.glob(os.path.join(target_path, config_pathname or '*.xcconfig'))]
    if configs:
        if len(configs) > 2:
            sys.stderr.write('Too many configuration files in %s: "%s".\n' % (os.path.abspath(target_path), '", "'.join(configs)))
            return False
    else:
        sys.stderr.write('Missing configuration file (%s) in %s.\n' % (config_pathname or '*.xcconfig', os.path.abspath(target_path)))
        return False
    return True

def recursive_overwrite(src, dest, ignore=None):
    if os.path.isdir(src):
        if not os.path.isdir(dest):
            os.makedirs(dest)
        files = os.listdir(src)
        if ignore is not None:
            ignored = ignore(src, files)
        else:
            ignored = set()
        for f in files:
            if f not in ignored:
                recursive_overwrite(os.path.join(src, f),
                                    os.path.join(dest, f),
                                    ignore)
    else:
        #sys.stderr.write("copy file: %s \n" % dest)
        shutil.copy2(src, dest)

def copyImages(src, dest):
    try:
        recursive_overwrite(src, dest, None)
    except OSError as e:
        sys.stderr.write('Error in image directory copying: %s \n' % e)
        return False
    return True

def configureTarget(target):
    target_path = os.path.join(TARGETS_DIR_PATH, target)

    # Check if specified target is valid
    if not check_target(target_path):
        sys.stderr.write("%s: invalid target.\n" % filename)
        return os.EX_CONFIG

    # Setup
    source_images_path = os.path.join(target_path, 'images')

    # copy images (if any)
    # dir_list = os.listdir(source_images_path)
    # if dir_list:
    #     for img in dir_list:
    #         try:
    #             shutil.copy2(os.path.join(source_images_path, img), os.path.join(os.pardir, 'resources', 'images'))
    #         except IOError as e:
    #             if e.errno != os.errno.EISDIR:
    #                 raise
    # else:
    #     sys.stderr.write('Warning:  %s was empty. \n' % os.path.abspath(source_images_path))
    target_images_path = os.path.join(os.pardir, 'resources', 'images')
    if not copyImages(source_images_path, target_images_path):
        raise

    # copy configuration files
    shutil.copy2(glob.glob(os.path.join(target_path, '*.xcconfig'))[0], os.path.join(os.pardir, 'src', 'iCalcio'))
    shutil.copy2(glob.glob(os.path.join(target_path, '*.xcconfig'))[1], os.path.join(os.pardir, 'src', 'iCalcio'))    

    #sys.stdout.write('trace After copy configuration file \n')

def buildTarget(target):
    target_profile_name = target

    sys.stdout.write("Init build of %s.. \n" % target)
    try:
        # Directories
        build_time = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        build_dir = "../../build"

        current_build_dir = ("%s/%s/%s" % (build_dir, target, build_time))
        if not os.path.isdir(current_build_dir):
            os.makedirs(current_build_dir)

        out_file = ("%s/out" % current_build_dir)
        err_file = ("%s/err" % current_build_dir)

        # provisioning profile for target, in profiles folder
        profiles_dir = './profiles'
        profile_name = "%s.mobileprovision" % target_profile_name

        if not os.path.isdir(profiles_dir):
            sys.stdout.write("Warning: profiles dir is missing.\n")

        # Call CLI Nomad tool for build
        dis_command = [
            "ipa",
            "build",
            "--scheme", "igamma",
            "--configuration", "Release",
            "--destination", current_build_dir,
            "--clean",
            "--archive",
            "--embed", "%s/%s" % (profiles_dir, profile_name),
            "--identity", "iPhone Distribution: Apex-net Srl (LVD55J8NH8)",
            "--verbose",
        ]
        sys.stdout.write("dis_command (print list): %s \n"  % ' '.join(dis_command))
        subprocess.check_call(dis_command, stdout=open(out_file,"a"), stderr=open(err_file,"a"))


        for file in os.listdir(current_build_dir):
          if file.endswith(".ipa"):
              #rename generated ipa to '<target>.ipa'
              ipaFileName = "%s.ipa" % target_profile_name
              ipaFilePath = "%s/%s" % (current_build_dir, file)
              ipaPath = "%s/%s" % (current_build_dir, ipaFileName)

              os.rename(ipaFilePath, ipaPath)

              #print ipa info
              dis_command = [
                  "ipa",
                  "info",
                  ipaPath
              ]
              sys.stdout.write("dis_command (print list): %s \n"  % ' '.join(dis_command))
              subprocess.check_call(dis_command, stdout=sys.stdout, stderr=sys.stdout)

    except subprocess.CalledProcessError as e:
        sys.stderr.write("Error ipa build code: %s \n"  % e.returncode)
        return os.EX_CONFIG

    sys.stdout.write("End build of %s. \n" % target)
    return os.EX_OK

def distributeTarget(target):

    project_build_dir = "../../build/%s" % (target)
    list = os.listdir(project_build_dir)
    sortedbuilds = sorted(list, key=str.lower, reverse=True)
    build_to_distribute = sortedbuilds[0]
    build_path = "../../build/%s/%s" % (target, build_to_distribute)
    out_file = ("%s/out" % build_path)
    err_file = ("%s/err" % build_path)

    sys.stdout.write("Going to distribute build %s \n" % build_to_distribute)

    # Call CLI Nomad tool for distribute to iTunes Connect
    sys.stdout.write("Init distribute of %s.. \n" % target)
    try:
        ipaFileName = "%s.ipa" % (target)
        ipaFile = "%s/%s" % (build_path, ipaFileName)
        dym = "%s/%s.app.dSYM.zip" % (build_path, target)
        iTMSFolder = "%s/%s" % (build_path, target)
        iTMSFile = "%s.itmsp" % (iTMSFolder)
        ipaXmlFile = "%s/metadata.xml" % (iTMSFolder)

        appSkus = {"DiWine":"838123903", "iB":"544373413", "iCommerce":"567772952", "iGamma":"417013645","AtipicoOrder":"700693596", "BtsrManager":"834330091", "iBIZ":"871060765", "wTrendy":"642932906", "iZeta":"700840887"}
        skuNumber = appSkus[target]
        ipaName = "%s.ipa" % (target)
        md5 = hashlib.md5(open(ipaFile, 'rb').read()).hexdigest()
        ipaSize = os.path.getsize(ipaFile)

        sys.stdout.write('ipaFileName: %s ipaFile: %s iTMSFolder: %s\n iTMSFile: %s ipaXmlFile: %s\n' % (ipaFileName, ipaFile, iTMSFolder, iTMSFile, ipaXmlFile))
        sys.stdout.write('sku: %s ipaname: %s md5: %s ipaSize:%s \n' % (skuNumber, ipaName, md5, ipaSize))

        xmlFileContent = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><package version=\"software4.7\" xmlns=\"http://apple.com/itunes/importer\"><software_assets apple_id=\"%s\"><asset type=\"bundle\"><data_file><file_name>%s</file_name><checksum type=\"md5\">%s</checksum><size>%s</size></data_file></asset></software_assets></package>" % (skuNumber, ipaName, md5, ipaSize)

        #create a folder to contain ipa and xml
        os.makedirs(iTMSFolder)

        xmlFile = open(ipaXmlFile, "w")
        xmlFile.write(xmlFileContent)
        xmlFile.close()

        #move ipa
        os.rename(ipaFile, "%s/%s" % (iTMSFolder, ipaFileName))

        #move ipa
        os.rename(iTMSFolder, iTMSFile)

        dis_command = [
            "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/MacOS/itms/bin/iTMSTransporter",
            "-u", "a.calisesi@apexnet.it",
            "-m", "upload",
            "-p", "Apexdev51",
            "-f", iTMSFile
        ]
        sys.stdout.write("dis_command (print list): %s \n"  % ' '.join(dis_command))
        subprocess.check_call(dis_command, stdout=open(out_file,"a"), stderr=open(err_file,"a"))
    except subprocess.CalledProcessError as e:
        sys.stderr.write("Error ipa distribute code: %s.\n"  % (e.returncode))
        return os.EX_CONFIG

    clean_git()
    sys.stdout.write("End distribute of %s. \n" % target)
    return os.EX_OK

def main():
    """TODOC."""
    args = parse_args()
    filename = os.path.split(__file__)[1]

    # Check if current directory contains a *.xcodeproj file
    if not check_xcode_setup():
        sys.stderr.write("%s: the directory %s does not contain an Xcode project.\n" % (filename, os.getcwd()))
        return os.EX_CONFIG

    # list all available targets
    if args.list:

        #sys.stdout.write('trace list \n')

        for t in os.listdir(TARGETS_DIR_PATH):
            path = os.path.join(TARGETS_DIR_PATH, t)
            if os.path.isdir(path) and not t.startswith('.'):
                sys.stdout.write('%s\n' % t)
        return os.EX_OK

    if args.target:

        # Check if current directory is under version control and that the working directory is clean
        try:
            sys.stdout.write('TODO: Uncommnet check_git \n')
            #if not check_git():
            #    sys.stderr.write("%s: invalid version control status.\n" % filename)
            #    return os.EX_CONFIG
        except VCSError:
            sys.stderr.write("%s: no valid version control system is found.\n" % filename)
            return os.EX_CONFIG

        configureTarget(args.target[0])

    if args.pods:
        alignPods()

    # Clean & Build ipa (Release mode)
    # using https://github.com/nomad/shenzhen.git
    # for example: $ipa build -s igamma -c "Release" --clean --archive
    if args.build:
        buildTarget(args.target[0])

    # Distribute ipa
    # using https://github.com/nomad/shenzhen.git
    if args.distribute:
        distributeTarget(args.target[0])

    # Process all targets
    if args.all:
        sys.stdout.write('Start compiling all targets.. \n')

        for t in os.listdir(TARGETS_DIR_PATH):
            path = os.path.join(TARGETS_DIR_PATH, t)
            if os.path.isdir(path) and not t.startswith('.'):

                sys.stdout.write('Going to process %s ..\n' % t)

                configureTarget(t)
                buildTarget(t)
                distributeTarget(t)
                clean_git()

                # refresh pods
                refreshPods()

                sys.stdout.write('End processing of %s.\n' % t)

    return os.EX_OK

if __name__ == '__main__':
    status = main()
    sys.exit(status)

# End of file
