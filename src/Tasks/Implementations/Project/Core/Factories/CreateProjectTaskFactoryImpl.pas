(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit CreateProjectTaskFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskIntf,
    TaskFactoryIntf,
    TextFileCreatorIntf,
    ContentModifierIntf;

type

    (*!--------------------------------------
     * Factory class for create project task
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TCreateProjectTaskFactory = class(TInterfacedObject, ITaskFactory)
    protected
        function buildProjectTask(
            const textFileCreator : ITextFileCreator;
            const contentModifier : IContentModifier
        ) : ITask; virtual;
    public
        function build() : ITask; virtual;
    end;

implementation

uses

    TextFileCreatorImpl,
    ContentModifierImpl,
    DirectoryCreatorImpl,
    CreateDirTaskImpl,
    CreateAppConfigsTaskImpl,
    CreateAdditionalFilesTaskImpl,
    CreateShellScriptsTaskImpl,
    CreateAppBootstrapTaskImpl,
    InitGitRepoTaskImpl,
    CommitGitRepoTaskImpl,
    CreateProjectTaskImpl,
    InvRunCheckTaskImpl,
    EmptyDirCheckTaskImpl,
    RegisterConfigDependencyTaskImpl,
    FileHelperAppendImpl,
    CompositeTaskImpl;

    function TCreateProjectTaskFactory.buildProjectTask(
        const textFileCreator : ITextFileCreator;
        const contentModifier : IContentModifier
    ) : ITask;
    begin
        result := TCreateProjectTask.create(
            TCreateDirTask.create(TDirectoryCreator.create()),
            TCreateShellScriptsTask.create(textFileCreator, contentModifier),
            TCompositeTask.create(
                TCreateAppConfigsTask.create(textFileCreator, contentModifier),
                TRegisterConfigDependencyTask.create(
                    textFileCreator,
                    contentModifier,
                    TFileHelperAppender.create()
                )
            ),
            TCreateAdditionalFilesTask.create(textFileCreator, contentModifier),
            TCreateAppBootstrapTask.create(textFileCreator, contentModifier),
            TInitGitRepoTask.create(TCommitGitRepoTask.create())
        );
    end;

    function TCreateProjectTaskFactory.build() : ITask;
    var textFileCreator : ITextFileCreator;
        contentModifier : IContentModifier;
        createPrjTask : ITask;
        invRunCheckTask : ITask;
    begin
        //TODO: refactor as this is similar to TCreateProjectFastCgiTaskFactory
        //or TCreateProjectScgiTaskFactory
        textFileCreator := TTextFileCreator.create();
        contentModifier := TContentModifier.create();
        createPrjTask := buildProjectTask(textFileCreator, contentModifier);

        //protect to avoid accidentally creating another project inside Fano-CLI
        //project directory structure
        invRunCheckTask := TInvRunCheckTask.create(createPrjTask);

        //protect to avoid accidentally creating project inside
        //existing and non empty directory
        result := TEmptyDirCheckTask.create(invRunCheckTask);
    end;

end.